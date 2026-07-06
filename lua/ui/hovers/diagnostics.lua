-- Forked from OXY2DEV (https://github.com/OXY2DEV/nvim/blob/main/lua/scripts/diagnostics.lua)
-- Fancy diagnostics hover for Neovim.

local api = vim.api
local floatpos = require("utils.floatpos")
local icons = vim.g.iconchars

local M = {}

------------------------------------------------------------------------------
-- Types
------------------------------------------------------------------------------

---@class diaghover.config
---@field keymap?           string
---@field decoration_width? integer | fun(items: table): integer
---@field width?            integer | fun(items: table): integer
---@field max_height?       integer | fun(): integer
---@field decorations?      table
---@field alpha?            number Background highlight blending ratio (default: 0.1)

------------------------------------------------------------------------------
-- Highlight Management
------------------------------------------------------------------------------

--- Dynamically generates FancyDiagnostic groups based on current colorscheme.
function M.__generate_highlights()
  floatpos.generate_kind_highlights("DiagnosticHover", {
    Default = { target = "@comment", fallback = "#9399b2" },
    Info = { target = "DiagnosticInfo", fallback = "#94e2d5" },
    Hint = { target = "DiagnosticHint", fallback = "#94e2d5" },
    Warn = { target = "DiagnosticWarn", fallback = "#f9e2af" },
    Error = { target = "DiagnosticError", fallback = "#f38ba8" },
  }, M.config.alpha
  )
end

--- Generates formatting and highlight group mappings for a specific diagnostic severity.
---@param level string The severity level name (e.g., "Error", "Warn").
---@param icon  string The icon to display for this severity.
---@return table decoration_config Configuration table containing width, line_hl_group, icon, and padding.
local function handle_diag_level(level, icon)
  local default = string.format("DiagnosticHover%s", "Default")
  local default_icon_hl = string.format("DiagnosticHover%sIcon", "Default")
  local bg = string.format("DiagnosticHover%s", level)
  local icon_hl = string.format("DiagnosticHover%sIcon", level)

  return {
    line_hl_group = function (_, current) return current and bg or default end,
    icon = function (_, current)
      return {
        { icons.misc.pad_line, current and icon_hl or default_icon_hl },
        { icon, current and icon_hl or default_icon_hl }, { " ", current and bg or default },
      }
    end,
    padding = function (_, current)
      return {
        { icons.misc.pad_line, current and icon_hl or default_icon_hl },
        { "  ", current and icon_hl or default_icon_hl }, { " ", current and bg or default },
      }
    end,
  }
end

------------------------------------------------------------------------------
-- Configuration
------------------------------------------------------------------------------

M.config = {
  keymap = "<leader><space>",
  decoration_width = 4,
  width = function (items)
    local max = math.floor(vim.o.columns * 0.4)
    local use = 1
    for _, item in ipairs(items) do
      for _, line in ipairs(vim.split(item.message or "", "\n", { trimempty = true })) do
        use = math.max(use, math.min(vim.fn.strdisplaywidth(line), max))
      end
    end
    return use
  end,
  max_height = function () return math.floor(vim.o.lines * 0.2) end,
  decorations = {
    [vim.diagnostic.severity.INFO] = handle_diag_level("Info", icons.diagnostics.Info),
    [vim.diagnostic.severity.HINT] = handle_diag_level("Hint", icons.diagnostics.Hint),
    [vim.diagnostic.severity.WARN] = handle_diag_level("Warn", icons.diagnostics.Warn),
    [vim.diagnostic.severity.ERROR] = handle_diag_level("Error", icons.diagnostics.Error),
    default = handle_diag_level("Default", "? "),
  },
  alpha = 0.1,
}

M.ns = api.nvim_create_namespace("diagnostic-hover")
M.buffer = nil
M.window = nil
M.quad = nil

------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------

--- Retrieves the evaluated decoration properties for a given diagnostic item.
---@param level integer | string The severity level key.
---@param ...   any              Arguments passed to the dynamic evaluators.
---@return table evaluated_decorations Map of resolved decoration properties.
local function get_decorations(level, ...)
  local output = {}
  local conf = M.config.decorations[level] or M.config.decorations["default"]
  if not conf then return output end
  for k, v in pairs(conf) do
    output[k] = floatpos.eval(v, ...)
  end
  return output
end

------------------------------------------------------------------------------
-- Window Generation Lifecycle
------------------------------------------------------------------------------

--- Populates the buffer with diagnostic strings and applies highlights and icons.
---@param items  table[]   The list of diagnostic items from `vim.diagnostic.get`.
---@param cursor integer[] The [row, col] position of the cursor.
---@return integer W        Total width.
---@return integer D        Decoration width padding.
---@return integer cursor_y The relative line index the cursor is currently resting on.
---@return table ranges     Location map to allow jumping to diagnostic.
local function build_buffer_state(items, cursor)
  local message_width = floatpos.eval(M.config.width, items)
  local D = floatpos.eval(M.config.decoration_width, items) or 0
  local W = message_width + D

  local diagnostic_lines = 0
  local cursor_y = 1
  local ranges = {}

  api.nvim_buf_set_lines(M.buffer, 0, -1, false, {})

  for i, item in ipairs(items) do
    local lines = {}
    for _, paragraph in ipairs(vim.split(item.message or "", "\n", { trimempty = true })) do
      vim.list_extend(lines, floatpos.wrap_text(paragraph, message_width))
    end
    if #lines == 0 then
      lines = { "" }
    end

    local current = (cursor[2] >= item.col and cursor[2] <= item.end_col)
    if current then cursor_y = diagnostic_lines + 1 end

    api.nvim_buf_set_lines(M.buffer, diagnostic_lines, -1, false, lines)
    local decorations = get_decorations(item.severity, item, current)
    ranges[i] = { item.lnum, item.col }

    for j = 1, #lines do
      api.nvim_buf_set_extmark(M.buffer, M.ns, diagnostic_lines + j - 1, 0, {
        virt_text = j == 1 and decorations.icon or decorations.padding,
        virt_text_pos = "inline",
        line_hl_group = decorations.line_hl_group,
      })
    end

    diagnostic_lines = diagnostic_lines + #lines
  end

  return W, D, cursor_y, ranges
end

--- Configures the floating window dimensions, borders, and appearance.
---@param source_win integer The window triggering the hover.
---@param W          integer Target width.
---@param D          integer Decoration padding offset.
---@param cursor_y   integer Target line inside the hover buffer to align with.
local function setup_window(source_win, W, D, cursor_y)
  local height_calc_config = {
    relative = "editor",
    row = 0,
    col = 1,
    width = math.max(10, W - D),
    height = 2,
    style = "minimal",
    hide = true,
  }

  if not M.window or not api.nvim_win_is_valid(M.window) then
    M.window = api.nvim_open_win(M.buffer, false, height_calc_config)
  else
    api.nvim_win_set_config(M.window, height_calc_config)
  end

  vim.wo[M.window].wrap = false

  local H = api.nvim_win_text_height(M.window, { start_row = 0, end_row = -1 }).all
  local pos = floatpos.compute(source_win, W, H)
  M.quad = pos.quad

  api.nvim_win_set_config(M.window, {
    relative = pos.relative,
    row = pos.row,
    col = pos.col,
    width = W,
    height = H,
    anchor = pos.anchor,
    border = pos.border,
    style = "minimal",
    hide = false,
  })

  api.nvim_win_set_cursor(M.window, { cursor_y, 0 })
  floatpos.set_quad(M.quad, true)

  vim.wo[M.window].signcolumn = "no"
  vim.wo[M.window].conceallevel = 3
  vim.wo[M.window].concealcursor = "ncv"
  vim.wo[M.window].winhl = "FloatBorder:@comment,Normal:Normal"

  api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre", "BufHidden" }, {
    group = api.nvim_create_augroup("diagnostic-hover-autoclose", { clear = true }),
    buffer = api.nvim_win_get_buf(source_win),
    callback = function ()
      if M.window and api.nvim_get_current_win() ~= M.window then
        M.close()
        return true
      end
    end,
  })
end

--- Injects navigation keymaps into the floating buffer.
---@param source_win integer The window to return focus to.
---@param ranges     table   Mapping of buffer lines to diagnostic locations.
local function attach_keymaps(source_win, ranges)
  api.nvim_buf_set_keymap(M.buffer, "n", "gl", "", {
    desc = "Go to diagnostic location",
    callback = function ()
      local _cursor = api.nvim_win_get_cursor(M.window)
      local location = ranges[_cursor[1]]
      if location then
        location[1] = location[1] + 1
        api.nvim_win_set_cursor(source_win, location)
        api.nvim_set_current_win(source_win)
        M.close()
      end
    end,
  })

  api.nvim_buf_set_keymap(M.buffer, "n", "q", "", {
    desc = "Exit diagnostics window",
    callback = function ()
      pcall(api.nvim_set_current_win, source_win)
      M.close()
    end,
  })
end

------------------------------------------------------------------------------
-- Activation
------------------------------------------------------------------------------

--- Closes the hover window and frees the used screen quadrant.
function M.close()
  floatpos.close(M)
end

--- Triggers the diagnostic hover window for the current line.
---@param window? integer The target window ID (defaults to current window).
function M.hover(window)
  window = window or api.nvim_get_current_win()
  local buffer = api.nvim_win_get_buf(window)
  local cursor = api.nvim_win_get_cursor(window)
  local items = vim.diagnostic.get(buffer, { lnum = cursor[1] - 1 })

  if #items == 0 then
    M.close()
    return api.nvim_echo({
      { " hovers/diagnostics ", "DiagnosticVirtualTextWarn" },
      { ": No diagnostic under cursor", "@comment" },
    }, true, {})
  elseif M.window and api.nvim_win_is_valid(M.window) then
    return api.nvim_set_current_win(M.window)
  end

  if M.quad then floatpos.set_quad(M.quad, false) end
  if not M.buffer or not api.nvim_buf_is_valid(M.buffer) then
    M.buffer = api.nvim_create_buf(false, true)
  end

  vim.bo[M.buffer].ft = "markdown"
  api.nvim_buf_clear_namespace(M.buffer, M.ns, 0, -1)

  local W, D, cursor_y, ranges = build_buffer_state(items, cursor)
  setup_window(window, W, D, cursor_y)
  attach_keymaps(window, ranges)
end

------------------------------------------------------------------------------
-- Init
------------------------------------------------------------------------------

if M.config.keymap then
  api.nvim_set_keymap("n", M.config.keymap, "", {
    callback = M.hover,
    desc = "Open diagnostic hover",
  })
end

return M
