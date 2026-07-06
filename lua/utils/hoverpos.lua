-- Shared dynamic positioning & sizing logic for cursor-anchored floating windows (hovers)

local api = vim.api
local M = {}

------------------------------------------------------------------------------
-- Types
------------------------------------------------------------------------------

---@alias hoverpos.quad "top_left" | "top_right" | "bottom_left" | "bottom_right" | "center"

---@class hoverpos.result
---@field border   string | table
---@field relative string
---@field anchor   string
---@field row      integer
---@field col      integer
---@field quad     hoverpos.quad

---@class hoverpos.state
---@field window integer?
---@field quad   hoverpos.quad?

------------------------------------------------------------------------------
-- Quadrant bookkeeping
------------------------------------------------------------------------------

-- Tracks occupied quadrants
M.used_quads = {}

-- Events to close float
M.close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre", "BufHidden" }

---@param quad  hoverpos.quad?
---@param state boolean
function M.set_quad(quad, state)
  if quad then M.used_quads[quad] = state end
end

------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------

--- Safely evaluates a dynamic property (function or static value).
---@param val any The value or function to evaluate.
---@param ... any Arguments to pass if `val` is a function.
---@return any evaluated_value
function M.eval(val, ...)
  if type(val) ~= "function" then return val end
  local ok, result = pcall(val, ...)
  return (ok and result ~= nil) and result or nil
end

--- Wraps a single line to fit within `width` display cells. A word that
--- alone exceeds `width` is hard-broken character-by-character so no row is
--- ever wider than `width`.
---@param text  string
---@param width integer Max display width per resulting row.
---@return string[] rows
function M.wrap_text(text, width)
  width = math.max(1, width)
  if vim.fn.strdisplaywidth(text) <= width then return { text } end

  local rows, line, line_w = {}, "", 0

  local function push_word(word, word_w)
    if word_w > width then
      if line_w > 0 then
        table.insert(rows, line)
        line, line_w = "", 0
      end
      for _, ch in ipairs(vim.fn.split(word, "\\zs")) do
        local ch_w = vim.fn.strdisplaywidth(ch)
        if line_w > 0 and line_w + ch_w > width then
          table.insert(rows, line)
          line, line_w = ch, ch_w
        else
          line, line_w = line .. ch, line_w + ch_w
        end
      end
      return
    end

    if line_w == 0 then
      line, line_w = word, word_w
    elseif line_w + 1 + word_w <= width then
      line, line_w = line .. " " .. word, line_w + 1 + word_w
    else
      table.insert(rows, line)
      line, line_w = word, word_w
    end
  end

  for word in text:gmatch("%S+") do
    push_word(word, vim.fn.strdisplaywidth(word))
  end
  if line ~= "" then table.insert(rows, line) end
  return rows
end

------------------------------------------------------------------------------
-- Positioning
------------------------------------------------------------------------------

local quadrants = {
  {
    quad = "bottom_right",
    anchor = "NW",
    row = 1,
    col = 0,
    border = { "├", "─", "╮", "│", "╯", "─", "╰", "│" },
    fits = function (sp, w, h, sw, sh) return sp.row + h <= sh and sp.curscol + w <= sw end,
  },
  {
    quad = "top_right",
    anchor = "SW",
    row = 0,
    col = 0,
    border = { "╭", "─", "╮", "│", "╯", "─", "├", "│" },
    fits = function (sp, _, h, sw, _) return h < sp.row and sp.curscol + 2 <= sw end,
  },
  {
    quad = "bottom_left",
    anchor = "NE",
    row = 1,
    col = 1,
    border = { "╭", "─", "┤", "│", "╯", "─", "╰", "│" },
    fits = function (sp, w, h, _, sh) return sp.row + h <= sh and sp.curscol > w end,
  },
  {
    quad = "top_left",
    anchor = "SE",
    row = 0,
    col = 1,
    border = { "╭", "─", "╮", "│", "┤", "─", "╰", "│" },
    fits = function (sp, w, h, _, _) return h < sp.row and sp.curscol > w end,
  },
}

--- Calculates the optimal floating window placement relative to the cursor
---@param window integer The source window whose cursor the float anchors to.
---@param w      integer The calculated width of the float.
---@param h      integer The calculated height of the float.
---@return hoverpos.result
function M.compute(window, w, h)
  local cursor = api.nvim_win_get_cursor(window)
  local screenpos = vim.fn.screenpos(window, cursor[1], cursor[2])
  local sw, sh = vim.o.columns - 2, vim.o.lines - vim.o.cmdheight - 2

  for _, q in ipairs(quadrants) do
    if not M.used_quads[q.quad] and q.fits(screenpos, w, h, sw, sh) then
      return {
        border = q.border,
        relative = "cursor",
        anchor = q.anchor,
        row = q.row,
        col = q.col,
        quad = q.quad,
      }
    end
  end

  return {
    border = "rounded",
    relative = "editor",
    anchor = "NW",
    row = math.ceil((vim.o.lines - h) / 2),
    col = math.ceil((vim.o.columns - w) / 2),
    quad = "center",
  }
end

------------------------------------------------------------------------------
-- Highlight generation
------------------------------------------------------------------------------

--- Regenerates a themed family of highlight groups from `groups`, each
--- mapping a semantic key (e.g. "Error", "Function") to a highlight to pull
--- a color from.
---@param prefix string
---@param groups table<string, { target: string, fallback: string }>
---@param alpha? number Blend ratio of the accent color into `Normal`'s bg (default 0.1).
function M.generate_kind_highlights(prefix, groups, alpha)
  local colors = require("utils.coloring")
  local bg_hl = api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_bg = bg_hl.bg or (vim.o.background == "dark" and "#1e1e2e" or "#eff1f5")
  alpha = alpha or 0.1

  for key, conf in pairs(groups) do
    local fg_hl = api.nvim_get_hl(0, { name = conf.target, link = false })
    local fg = fg_hl.fg or conf.fallback

    local hex_fg = colors.hex(colors.parse(fg))
    local blended_bg = colors.blend(fg, normal_bg, alpha)

    api.nvim_set_hl(0, prefix .. key, { fg = hex_fg, bg = blended_bg })
    api.nvim_set_hl(0, prefix .. key .. "Icon", { fg = normal_bg, bg = hex_fg })
  end
end

--- Generates a single highlight group whose fg is `Normal`'s fg blended
--- towards `Normal`'s bg
---@param name   string
---@param ratio? number Blend ratio kept from the original fg (default 0.45); lower fades more.
function M.generate_muted_highlight(name, ratio)
  local colors = require("utils.coloring")
  local normal = api.nvim_get_hl(0, { name = "Normal", link = false })
  local fg = normal.fg or "#cdd6f4"
  local bg = normal.bg or (vim.o.background == "dark" and "#181D21") or "#F2F3F4"
  api.nvim_set_hl(0, name, {
    fg = colors.blend(fg, bg, ratio or 0.45),
  })
end

------------------------------------------------------------------------------
-- Utility
------------------------------------------------------------------------------

--- Closes a float previously positioned with `M.compute` and frees its quadrant
---@param state hoverpos.state
function M.close(state)
  if state.window and api.nvim_win_is_valid(state.window) then
    pcall(api.nvim_win_close, state.window, true)
    state.window = nil
  end
  if state.quad then
    M.set_quad(state.quad, false)
    state.quad = nil
  end
end

--- Warns if there's no content to push into float
---@param name string Name of float/hover
---@param msg  string
function M.notify_empty(name, msg)
  api.nvim_echo({
    { string.format(" hovers/%s ", name), "DiagnosticVirtualTextWarn" },
    { ": " .. msg, "@comment" },
  }, true, {})
end

return M
