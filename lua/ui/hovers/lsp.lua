-- Dynamically positioned, kind-aware LSP hover float

local api = vim.api
local hoverpos = require("utils.hoverpos")
local M = {}

------------------------------------------------------------------------------
-- Types
------------------------------------------------------------------------------

---@class lsphover.config
---@field keymap?     string Normal-mode mapping that triggers hover (default "K").
---@field max_width?  integer | fun(): integer
---@field max_height? integer | fun(): integer
---@field alpha?      number Accent blend ratio for the border/title badge (default 0.12).
---@field dim_alpha?  number How much of the original fg survives in dimmed docs (default 0.45).

------------------------------------------------------------------------------
-- Configuration
------------------------------------------------------------------------------

M.config = {
  keymap = "K",
  max_width = function () return math.floor(vim.o.columns * 0.55) end,
  max_height = function () return math.floor(vim.o.lines * 0.4) end,
  alpha = 0.12,
  dim_alpha = 0.55,
}

M.ns = api.nvim_create_namespace("lsp_hover")
M.window = nil
M.quad = nil
M.docs_line = nil

------------------------------------------------------------------------------
-- Kind classification
------------------------------------------------------------------------------

-- What each kind's accent color is sampled from
local kind_types = {
  default = { target = "@comment", fallback = "#9399b2" },
  class = { target = "@type", fallback = "#f9e2af" },
  interface = { target = "@type", fallback = "#f9e2af" },
  struct = { target = "@type", fallback = "#f9e2af" },
  enum = { target = "@type", fallback = "#f9e2af" },
  method = { target = "@function.method", fallback = "#89b4fa" },
  ["function"] = { target = "@function", fallback = "#89b4fa" },
  property = { target = "@property", fallback = "#94e2d5" },
  parameter = { target = "@variable.parameter", fallback = "#eba0ac" },
  variable = { target = "@variable", fallback = "#cdd6f4" },
  keyword = { target = "@keyword", fallback = "#cba6f7" },
  module = { target = "@module", fallback = "#94e2d5" },
  constant = { target = "@constant", fallback = "#fab387" },
}

-- A generic glyph for when nothing classifies
local default_icon = "●"

-- Maps a treesitter/semantic-token capture name to one of `kind_types`'s keys.
local ts_kind_captures = {
  { "^@lsp%.type%.class", "class" }, { "^@lsp%.type%.interface", "interface" },
  { "^@lsp%.type%.struct", "struct" }, { "^@lsp%.type%.enum", "enum" },
  { "^@lsp%.type%.type", "class" }, { "^@type", "class" }, { "^@lsp%.type%.method", "method" },
  { "^@function%.method", "method" }, { "^@method", "method" },
  { "^@lsp%.type%.function", "function" }, { "^@function", "function" },
  { "^@lsp%.type%.property", "property" }, { "^@property", "property" },
  { "^@lsp%.type%.parameter", "parameter" }, { "^@variable%.parameter", "parameter" },
  { "^@lsp%.type%.variable", "variable" }, { "^@variable", "variable" },
  { "^@lsp%.type%.keyword", "keyword" }, { "^@keyword", "keyword" },
  { "^@lsp%.type%.namespace", "module" }, { "^@module", "module" },
  { "^@lsp%.type%.enumMember", "constant" }, { "^@constant", "constant" },
}

--- Classifies the symbol at `(row, col)` into one of `kind_types`'s keys,
--- using whatever treesitter capture is available.
---@param bufnr integer
---@param row   integer 0-indexed
---@param col   integer 0-indexed
---@return string kind
local function detect_kind(bufnr, row, col)
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, bufnr, row, col)
  if not ok or not captures then return "default" end

  for i = #captures, 1, -1 do
    local name = "@" .. captures[i].capture
    for _, entry in ipairs(ts_kind_captures) do
      if name:match(entry[1]) then return entry[2] end
    end
  end
  return "default"
end

------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------

--- Finds where the "signature" portion of the hover content ends, so
--- everything after it can be dimmed and visually separated.
---@param lines string[]
---@return integer? docs_start   The first 0-indexed line belonging to the docs.
---@return boolean needs_divider Whether a synthetic divider should be drawn there.
local function find_signature_end(lines)
  for i, line in ipairs(lines) do
    if line:match("^%s*%-%-%-+%s*$") then
      return i - 1, false
    end
  end

  -- fall back to the first code block
  if lines[1] and lines[1]:match("^%s*```") then
    for i = 2, #lines do
      if lines[i]:match("^%s*```%s*$") then
        return i, true
      end
    end
  end

  return nil, false
end

--- Derives `kind`'s glyph, label, and the highlight used to tint its border/title/divider.
---@param kind string A key into `kind_types`.
---@return { icon: string, label: string, hl_suffix: string }
local function kind_display(kind)
  local hl_suffix = kind:gsub("^%l", string.upper)
  return {
    icon = vim.g.iconchars.kinds[kind] or default_icon,
    label = (kind == "default") and "Symbol" or hl_suffix,
    hl_suffix = hl_suffix,
  }
end

--- A footer hinting that more content is available
---@param lines  string[]
---@param width  integer
---@param height integer
---@return table? footer_chunks
local function truncation_footer(lines, width, height)
  local rows = 0
  for _, line in ipairs(lines) do
    rows = rows + #hoverpos.wrap_text(line, width)
    if rows > height then
      return { { string.format(" ⋯ press %s to enter ", M.config.keymap), "LspHoverMuted" } }
    end
  end
  return nil
end

------------------------------------------------------------------------------
-- Highlight Management
------------------------------------------------------------------------------

--- Dynamically regenerates LspHover* groups based on the current colorscheme.
function M.__generate_highlights()
  hoverpos.generate_kind_highlights("LspHover", kind_types, M.config.alpha)
  hoverpos.generate_muted_highlight("LspHoverMuted", M.config.dim_alpha)
end

------------------------------------------------------------------------------
-- Documentation Re-wrap
------------------------------------------------------------------------------

-- Line prefixes marking structural markdown we should never reformat
local STRUCTURAL_LINE = "^%s*[#>]" -- headings, block quotes
local LIST_ITEM_LINE = "^%s*[%-%*%+]%s" -- "- foo", "* foo", "+ foo"
local ORDERED_ITEM_LINE = "^%s*%d+[%.%)]%s" -- "1. foo", "2) foo"
local THEMATIC_BREAK_LINE = "^%s*%-%-%-+%s*$" -- "---"

--- Rewraps paragraphs in `lines` to fit `width`
---@param lines string[]
---@param width integer
---@return string[]
local function rewrap_align(lines, width)
  local out = {}
  local paragraph = {}
  local in_code_block = false

  local function flush_paragraph()
    if #paragraph == 0 then return end
    vim.list_extend(out, hoverpos.wrap_text(table.concat(paragraph, " "), width))
    paragraph = {}
  end

  for _, line in ipairs(lines) do
    if line:match("^%s*```") then
      flush_paragraph()
      in_code_block = not in_code_block
      table.insert(out, line)
    elseif in_code_block or line:match("^%s*$")
      or line:match(STRUCTURAL_LINE) or line:match(LIST_ITEM_LINE)
      or line:match(ORDERED_ITEM_LINE) or line:match(THEMATIC_BREAK_LINE) then
      flush_paragraph()
      table.insert(out, line)
    else
      table.insert(paragraph, vim.trim(line))
    end
  end
  flush_paragraph()

  return out
end

------------------------------------------------------------------------------
-- Window Generation
------------------------------------------------------------------------------

--- Positions an already-opened floating preview window with the shared
--- quadrant logic and claims its quadrant.
---@param source_win integer The window that requested the hover.
---@param float_win  integer The floating window returned by `open_floating_preview`.
---@return hoverpos.result pos
---@return integer width
---@return integer height
local function place_window(source_win, float_win)
  local width = api.nvim_win_get_width(float_win)
  local height = api.nvim_win_get_height(float_win)
  local pos = hoverpos.compute(source_win, width, height)

  M.quad = pos.quad
  hoverpos.set_quad(pos.quad, true)

  return pos, width, height
end

--- Applies position and kind-accented border/title/footer/winhl to
--- the float in one window-config update.
---@param float_win integer
---@param pos       hoverpos.result                                    The placement from `place_window`.
---@param display   { icon: string, label: string, hl_suffix: string } From `kind_display`.
---@param lines     string[]                                           The markdown lines the float was opened with.
---@param width     integer
---@param height    integer
local function style_window(float_win, pos, display, lines, width, height)
  local win_config = {
    relative = pos.relative,
    anchor = pos.anchor,
    row = pos.row,
    col = pos.col,
    border = pos.border,
    title = {
      {
        string.format(" %s %s ", display.icon, display.label),
        "LspHover" .. display.hl_suffix .. "Icon",
      },
    },
    title_pos = "center",
  }

  local footer = truncation_footer(lines, width, height)
  if footer then
    win_config.footer = footer
    win_config.footer_pos = "right"
  end

  api.nvim_win_set_config(float_win, win_config)
  vim.wo[float_win].cursorline = false
  vim.wo[float_win].winhl = "FloatBorder:LspHover" .. display.hl_suffix
    .. ",NormalFloat:NormalFloat"
end

--- Dims the doc lines beneath the signature and, when the content has no
--- built-in separator, draws an accent-colored divider between the two.
---@param float_buf integer
---@param lines     string[] The markdown lines the float was opened with.
---@param hl_suffix string   From `kind_display(kind).hl_suffix`.
---@param width     integer
local function style_content(float_buf, lines, hl_suffix, width)
  local docs_start, needs_divider = find_signature_end(lines)
  local total_lines = api.nvim_buf_line_count(float_buf)
  if not (docs_start and docs_start < total_lines) then
    M.docs_line = nil
    return
  end

  api.nvim_buf_clear_namespace(float_buf, M.ns, 0, -1)

  local divider_line = docs_start - 1
  if needs_divider and divider_line >= 0 and divider_line < total_lines then
    api.nvim_buf_set_extmark(float_buf, M.ns, divider_line, 0, {
      virt_lines = { { { string.rep("─", width), "LspHover" .. hl_suffix } } },
    })
  end

  for line = docs_start, total_lines - 1 do
    api.nvim_buf_set_extmark(float_buf, M.ns, line, 0, {
      end_line = line + 1,
      hl_group = "LspHoverMuted",
      hl_eol = true,
      priority = 100,
    })
  end

  -- Remembers where the documentation starts
  M.docs_line = needs_divider and docs_start or math.min(docs_start + 1, total_lines - 1)
end

--- Frees the float's quadrant whenever it closes
---@param float_win integer
local function watch_for_close(float_win)
  api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(float_win),
    once = true,
    callback = function ()
      hoverpos.close(M)
    end,
  })
end

------------------------------------------------------------------------------
-- Activation
------------------------------------------------------------------------------

--- Requests hover information for the symbol under the cursor and opens it
--- in a dynamically positioned, kind-accented float. Focuses the float if
--- it's already open.
---@param window? integer The target window ID (defaults to current window).
function M.open(window)
  window = window or api.nvim_get_current_win()

  if M.window and api.nvim_win_is_valid(M.window) then
    api.nvim_set_current_win(M.window)
    if M.docs_line then
      pcall(api.nvim_win_set_cursor, M.window, { M.docs_line + 1, 0 })
    end
    return
  end

  local bufnr = api.nvim_win_get_buf(window)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
  if #clients == 0 then
    return hoverpos.notify_empty("lsp", "No diagnostic under cursor")
  end

  local cursor = api.nvim_win_get_cursor(window)
  local kind = detect_kind(bufnr, cursor[1] - 1, cursor[2])
  local params = vim.lsp.util.make_position_params(window, clients[1].offset_encoding)

  vim.lsp.buf_request(bufnr, "textDocument/hover", params, function (err, result)
    if err or not result or not result.contents then return end

    local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if vim.tbl_isempty(lines) then return end

    local max_width = hoverpos.eval(M.config.max_width)
    lines = rewrap_align(lines, max_width)

    local float_buf, float_win = vim.lsp.util.open_floating_preview(lines, "markdown", {
      max_width = max_width,
      max_height = hoverpos.eval(M.config.max_height),
      focus_id = "lsp-hover",
      focusable = true,
      close_events = hoverpos.close_events,
    })

    M.window = float_win
    local display = kind_display(kind)
    local pos, width, height = place_window(window, float_win)
    style_window(float_win, pos, display, lines, width, height)
    style_content(float_buf, lines, display.hl_suffix, width)
    watch_for_close(float_win)
  end)
end

return M
