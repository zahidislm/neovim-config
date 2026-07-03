-- Forked from OXY2DEV (https://github.com/OXY2DEV/nvim/blob/main/lua/scripts/diagnostics.lua)
-- Fancy diagnostics hover for Neovim.

local colors = require("ui.highlights.coloring")
local floatpos = require("utils.floatpos")
local icons = vim.g.iconchars

local diaghover = {}

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
function diaghover.__generate_highlights()
  local bg_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_bg = bg_hl.bg or (vim.o.background == "dark" and "#1e1e2e" or "#eff1f5")
  local alpha = diaghover.config.alpha or 0.1

  local groups = {
    Default = { target = "@comment", fallback = "#9399b2" },
    Info = { target = "DiagnosticInfo", fallback = "#94e2d5" },
    Hint = { target = "DiagnosticHint", fallback = "#94e2d5" },
    Warn = { target = "DiagnosticWarn", fallback = "#f9e2af" },
    Error = { target = "DiagnosticError", fallback = "#f38ba8" },
  }

  for kind, conf in pairs(groups) do
    local fg_hl = vim.api.nvim_get_hl(0, { name = conf.target, link = false })
    local fg = fg_hl.fg or conf.fallback

    local hex_fg = colors.hex(colors.parse(fg))
    local blended_bg = colors.blend(fg, normal_bg, alpha)

    vim.api.nvim_set_hl(0, string.format("FancyDiagnostic%s", kind), {
      fg = hex_fg,
      bg = blended_bg,
    })

    vim.api.nvim_set_hl(0, string.format("FancyDiagnostic%sIcon", kind), {
      fg = normal_bg,
      bg = hex_fg,
    })
  end
end

--- Generates formatting and highlight group mappings for a specific diagnostic severity.
---@param level string The severity level name (e.g., "Error", "Warn").
---@param icon  string The icon to display for this severity.
---@return table decoration_config Configuration table containing width, line_hl_group, icon, and padding.
local function handle_diagnostic_level(level, icon)
  local default = string.format("FancyDiagnostic%s", "Default")
  local default_icon_hl = string.format("FancyDiagnostic%sIcon", "Default")
  local bg = string.format("FancyDiagnostic%s", level)
  local icon_hl = string.format("FancyDiagnostic%sIcon", level)

  return {
    width = 3,
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
-- Helpers
------------------------------------------------------------------------------

--- Retrieves the evaluated decoration properties for a given diagnostic item.
---@param level integer | string The severity level key.
---@param ...   any              Arguments passed to the dynamic evaluators.
---@return table evaluated_decorations Map of resolved decoration properties.
local function get_decorations(level, ...)
  local output = {}
  local conf = diaghover.config.decorations[level] or diaghover.config.decorations["default"]
  if not conf then return output end
  for k, v in pairs(conf) do
    output[k] = floatpos.eval(v, ...)
  end
  return output
end

------------------------------------------------------------------------------
-- Core Configuration
------------------------------------------------------------------------------

diaghover.config = {
  keymap = "<leader><space>",
  decoration_width = 4,
  width = function (items)
    local max = math.floor(vim.o.columns * 0.4)
    local use = 1
    for _, item in ipairs(items) do
      for _, line in ipairs(vim.split(item.message or "", "\n", { trimempty = true })) do
        use = math.min(math.max(vim.fn.strdisplaywidth(line), use), max)
      end
    end
    return use
  end,
  max_height = function () return math.floor(vim.o.lines * 0.2) end,
  decorations = {
    [vim.diagnostic.severity.INFO] = handle_diagnostic_level("Info", icons.diagnostics.Info),
    [vim.diagnostic.severity.HINT] = handle_diagnostic_level("Hint", icons.diagnostics.Hint),
    [vim.diagnostic.severity.WARN] = handle_diagnostic_level("Warn", icons.diagnostics.Warn),
    [vim.diagnostic.severity.ERROR] = handle_diagnostic_level("Error", icons.diagnostics.Error),
    default = handle_diagnostic_level("Default", "? "),
  },
  alpha = 0.1,
}

diaghover.ns = vim.api.nvim_create_namespace("diagnostic-hover")
diaghover.buffer = nil
diaghover.window = nil
diaghover.quad = nil

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
---@return integer? level   The highest severity level found.
function diaghover.__build_buffer_state(items, cursor)
  local message_width = floatpos.eval(diaghover.config.width, items)
  local D = floatpos.eval(diaghover.config.decoration_width, items) or 0
  local W = message_width + D

  local diagnostic_lines = 0
  local cursor_y = 1
  local ranges = {}
  local level

  vim.api.nvim_buf_set_lines(diaghover.buffer, 0, -1, false, {})

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

    vim.api.nvim_buf_set_lines(diaghover.buffer, diagnostic_lines, -1, false, lines)
    local decorations = get_decorations(item.severity, item, current)
    ranges[i] = { item.lnum, item.col }

    for j = 1, #lines do
      vim.api.nvim_buf_set_extmark(diaghover.buffer, diaghover.ns, diagnostic_lines + j - 1, 0, {
        virt_text = j == 1 and decorations.icon or decorations.padding,
        virt_text_pos = "inline",
        line_hl_group = decorations.line_hl_group,
      })
    end

    diagnostic_lines = diagnostic_lines + #lines
    if current == true and (not level or item.severity < level) then level = item.severity end
  end

  return W, D, cursor_y, ranges, level
end

--- Configures the floating window dimensions, borders, and appearance.
---@param source_win integer The window triggering the hover.
---@param W          integer Target width.
---@param D          integer Decoration padding offset.
---@param cursor_y   integer Target line inside the hover buffer to align with.
function diaghover.__setup_window(source_win, W, D, cursor_y)
  local height_calc_config = {
    relative = "editor",
    row = 0,
    col = 1,
    width = math.max(1, W - D),
    height = 2,
    style = "minimal",
    hide = true,
  }

  if not diaghover.window or not vim.api.nvim_win_is_valid(diaghover.window) then
    diaghover.window = vim.api.nvim_open_win(diaghover.buffer, false, height_calc_config)
  else
    vim.api.nvim_win_set_config(diaghover.window, height_calc_config)
  end

  _G.diaghover.window = diaghover.window
  vim.wo[diaghover.window].wrap = false

  local H = vim.api.nvim_win_text_height(diaghover.window, { start_row = 0, end_row = -1 }).all
  local pos = floatpos.compute(source_win, W, H)
  diaghover.quad = pos.quad

  vim.api.nvim_win_set_config(diaghover.window, {
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

  vim.api.nvim_win_set_cursor(diaghover.window, { cursor_y, 0 })
  floatpos.set_quad(diaghover.quad, true)

  vim.wo[diaghover.window].signcolumn = "no"
  vim.wo[diaghover.window].conceallevel = 3
  vim.wo[diaghover.window].concealcursor = "ncv"
  vim.wo[diaghover.window].winhl = "FloatBorder:@comment,Normal:Normal"
end

--- Injects navigation keymaps into the floating buffer.
---@param source_win integer The window to return focus to.
---@param ranges     table   Mapping of buffer lines to diagnostic locations.
function diaghover.__attach_keymaps(source_win, ranges)
  vim.api.nvim_buf_set_keymap(diaghover.buffer, "n", "<CR>", "", {
    desc = "Go to diagnostic location",
    callback = function ()
      local _cursor = vim.api.nvim_win_get_cursor(diaghover.window)
      local location = ranges[_cursor[1]]
      if location then
        location[1] = location[1] + 1
        vim.api.nvim_win_set_cursor(source_win, location)
        vim.api.nvim_set_current_win(source_win)
        diaghover.close()
      end
    end,
  })

  vim.api.nvim_buf_set_keymap(diaghover.buffer, "n", "q", "", {
    desc = "Exit diagnostics window",
    callback = function ()
      pcall(vim.api.nvim_set_current_win, source_win)
      diaghover.close()
    end,
  })
end

------------------------------------------------------------------------------
-- Module Exports
------------------------------------------------------------------------------

--- Closes the hover window and frees the used screen quadrant.
function diaghover.close()
  floatpos.close(diaghover)
end

--- Triggers the diagnostic hover window for the current line.
---@param window? integer The target window ID (defaults to current window).
function diaghover.hover(window)
  window = window or vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_win_get_buf(window)
  local cursor = vim.api.nvim_win_get_cursor(window)
  local items = vim.diagnostic.get(buffer, { lnum = cursor[1] - 1 })

  if #items == 0 then
    diaghover.close()
    return vim.api.nvim_echo({
      { " diagnostics.lua ", "DiagnosticVirtualTextWarn" },
      { ": No diagnostic under cursor", "@comment" },
    }, true, {})
  elseif diaghover.window and vim.api.nvim_win_is_valid(diaghover.window) then
    return vim.api.nvim_set_current_win(diaghover.window)
  end

  if diaghover.quad then floatpos.set_quad(diaghover.quad, false) end
  if not diaghover.buffer or not vim.api.nvim_buf_is_valid(diaghover.buffer) then
    diaghover.buffer = vim.api
      .nvim_create_buf(false, true)
  end

  vim.bo[diaghover.buffer].ft = "markdown"
  vim.api.nvim_buf_clear_namespace(diaghover.buffer, diaghover.ns, 0, -1)

  local W, D, cursor_y, ranges = diaghover.__build_buffer_state(items, cursor)
  diaghover.__setup_window(window, W, D, cursor_y)
  diaghover.__attach_keymaps(window, ranges)
end

------------------------------------------------------------------------------
-- Init
------------------------------------------------------------------------------

if diaghover.config.keymap then
  vim.api.nvim_set_keymap("n", diaghover.config.keymap, "", {
    callback = diaghover.hover,
    desc = "Open diagnostic hover",
  })
end

_G.diaghover = { hover = diaghover.hover, close = diaghover.close }

return diaghover
