-- Forked from OXY2DEV (https://github.com/OXY2DEV/nvim/blob/main/lua/scripts/diagnostics.lua)
-- Fancy diagnostics hover for Neovim.

local colours = require("ui.highlights.coloring")
local icons = vim.g.iconchars

------------------------------------------------------------------------------
-- Types
------------------------------------------------------------------------------

---@class diagnostics.config
---@field keymap?           string
---@field decoration_width? integer | fun(items: table): integer
---@field width?            integer | fun(items: table): integer
---@field max_height?       integer | fun(): integer
---@field decorations?      table
---@field alpha?            number Background highlight blending ratio (default: 0.1)

------------------------------------------------------------------------------
-- Initialization
------------------------------------------------------------------------------

_G.__used_quads = _G.__used_quads or {}
local diagnostics = {}

------------------------------------------------------------------------------
-- Highlight Management
------------------------------------------------------------------------------

--- Dynamically generates FancyDiagnostic groups based on current colorscheme.
function diagnostics.__generate_highlights()
  local bg_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_bg = bg_hl.bg or (vim.o.background == "dark" and "#1e1e2e" or "#eff1f5")
  local alpha = diagnostics.config.alpha or 0.1

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

    local hex_fg = colours.hex(colours.parse(fg))
    local blended_bg = colours.blend(fg, normal_bg, alpha)

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

--- Safely evaluates a dynamic property (function or static value).
---@param val any The value or function to evaluate.
---@param ... any Arguments to pass if `val` is a function.
---@return any evaluated_value The resulting value.
local function eval(val, ...)
  if type(val) ~= "function" then return val end
  local can_call, new_val = pcall(val, ...)
  return (can_call and new_val ~= nil) and new_val or nil
end

--- wraps a single line to fit within `width`
--- display cells. A word that alone exceeds `width` is hard-broken
--- character-by-character so no row is ever wider than `width`.
---@param text  string
---@param width integer Max display width per resulting row.
---@return string[] rows
local function wrap_text(text, width)
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

--- Retrieves the evaluated decoration properties for a given diagnostic item.
---@param level integer | string The severity level key.
---@param ...   any              Arguments passed to the dynamic evaluators.
---@return table evaluated_decorations Map of resolved decoration properties.
local function get_decorations(level, ...)
  local output = {}
  local conf = diagnostics.config.decorations[level] or diagnostics.config.decorations["default"]
  if not conf then return output end
  for k, v in pairs(conf) do
    output[k] = eval(v, ...)
  end
  return output
end

------------------------------------------------------------------------------
-- Core Configuration
------------------------------------------------------------------------------

diagnostics.config = {
  keymap = "<leader><space>",
  decoration_width = 4,
  alpha = 0.1,
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
}

diagnostics.ns = vim.api.nvim_create_namespace("fancy_diagnostics")
diagnostics.buffer = nil
diagnostics.window = nil
diagnostics.quad = nil

------------------------------------------------------------------------------
-- UI Layout & Math
------------------------------------------------------------------------------

--- Updates the global state tracking which quadrant is currently occupied.
---@param quad  string  The quadrant identifier.
---@param state boolean True if occupied, false if freed.
function diagnostics.update_quad(quad, state)
  if _G.__used_quads then _G.__used_quads[quad] = state end
end

--- Calculates optimal floating window position via short-circuit evaluation.
---@param window integer The source window ID.
---@param w      integer The calculated width of the hover window.
---@param h      integer The calculated height of the hover window.
---@return string|table border, string relative, string anchor, integer row, integer col
function diagnostics.__win_args(window, w, h)
  local cursor = vim.api.nvim_win_get_cursor(window)
  local screenpos = vim.fn.screenpos(window, cursor[1], cursor[2])
  local screen_width = vim.o.columns - 2
  local screen_height = vim.o.lines - vim.o.cmdheight - 2

  -- Bottom Right Priority
  if not _G.__used_quads["bottom_right"] and (screenpos.row + h <= screen_height)
    and (screenpos.curscol + w <= screen_width) then
    diagnostics.quad = "bottom_right"
    return { "├", "─", "╮", "│", "╯", "─", "╰", "│" }, "cursor", "NW", 1, 0

    -- Top Right Fallback
  elseif not _G.__used_quads["top_right"] and h < screenpos.row
    and (screenpos.curscol + 2 <= screen_width) then
    diagnostics.quad = "top_right"
    return { "╭", "─", "╮", "│", "╯", "─", "├", "│" }, "cursor", "SW", 0, 0

    -- Bottom Left Fallback
  elseif not _G.__used_quads["bottom_left"] and (screenpos.row + h <= screen_height)
    and screenpos.curscol > w then
    diagnostics.quad = "bottom_left"
    return { "╭", "─", "┤", "│", "╯", "─", "╰", "│" }, "cursor", "NE", 1, 1

    -- Top Left Fallback
  elseif not _G.__used_quads["top_left"] and h < screenpos.row and screenpos.curscol > w then
    diagnostics.quad = "top_left"
    return { "╭", "─", "╮", "│", "┤", "─", "╰", "│" }, "cursor", "SE", 0, 1
  end

  -- Default to Center if no cursor-relative quadrant fits securely
  diagnostics.quad = "center"
  return "rounded",
    "editor", "NW",
    math.ceil((vim.o.lines - h) / 2), math.ceil((vim.o.columns - w) / 2)
end

--- Closes the hover window and frees the used screen quadrant.
function diagnostics.close()
  if diagnostics.window and vim.api.nvim_win_is_valid(diagnostics.window) then
    pcall(vim.api.nvim_win_close, diagnostics.window, true)
    diagnostics.window = nil
  end
  if diagnostics.quad then
    diagnostics.update_quad(diagnostics.quad, false)
    diagnostics.quad = nil
  end
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
---@return integer? level   The highest severity level found.
function diagnostics.__build_buffer_state(items, cursor)
  local message_width = eval(diagnostics.config.width, items)
  local D = eval(diagnostics.config.decoration_width, items) or 0
  local W = message_width + D

  local diagnostic_lines = 0
  local cursor_y = 1
  local ranges = {}
  local level

  vim.api.nvim_buf_set_lines(diagnostics.buffer, 0, -1, false, {})

  for i, item in ipairs(items) do
    local lines = {}
    for _, paragraph in ipairs(vim.split(item.message or "", "\n", { trimempty = true })) do
      vim.list_extend(lines, wrap_text(paragraph, message_width))
    end
    if #lines == 0 then
      lines = { "" }
    end

    local current = (cursor[2] >= item.col and cursor[2] <= item.end_col)
    if current then cursor_y = diagnostic_lines + 1 end

    vim.api.nvim_buf_set_lines(diagnostics.buffer, diagnostic_lines, -1, false, lines)
    local decorations = get_decorations(item.severity, item, current)
    ranges[i] = { item.lnum, item.col }

    for j = 1, #lines do
      vim.api.nvim_buf_set_extmark(diagnostics.buffer, diagnostics.ns, diagnostic_lines + j - 1, 0, {
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
function diagnostics.__setup_window(source_win, W, D, cursor_y)
  local height_calc_config = {
    relative = "editor",
    row = 0,
    col = 1,
    width = math.max(1, W - D),
    height = 2,
    style = "minimal",
    hide = true,
  }

  if not diagnostics.window or not vim.api.nvim_win_is_valid(diagnostics.window) then
    diagnostics.window = vim.api.nvim_open_win(diagnostics.buffer, false, height_calc_config)
  else
    vim.api.nvim_win_set_config(diagnostics.window, height_calc_config)
  end

  vim.wo[diagnostics.window].wrap = false

  local H = vim.api.nvim_win_text_height(diagnostics.window, { start_row = 0, end_row = -1 }).all
  local border, relative, anchor, row, col = diagnostics.__win_args(source_win, W, H)

  vim.api.nvim_win_set_config(diagnostics.window, {
    relative = relative or "cursor",
    row = row or 0,
    col = col or 0,
    width = W,
    height = H,
    anchor = anchor,
    border = border or "none",
    style = "minimal",
    hide = false,
  })

  vim.api.nvim_win_set_cursor(diagnostics.window, { cursor_y, 0 })
  diagnostics.update_quad(diagnostics.quad, true)

  vim.wo[diagnostics.window].signcolumn = "no"
  vim.wo[diagnostics.window].conceallevel = 3
  vim.wo[diagnostics.window].concealcursor = "ncv"
  vim.wo[diagnostics.window].winhl = "FloatBorder:@comment,Normal:Normal"
end

--- Injects navigation keymaps into the floating buffer.
---@param source_win integer The window to return focus to.
---@param ranges     table   Mapping of buffer lines to diagnostic locations.
function diagnostics.__attach_keymaps(source_win, ranges)
  vim.api.nvim_buf_set_keymap(diagnostics.buffer, "n", "<CR>", "", {
    desc = "Go to diagnostic location",
    callback = function ()
      local _cursor = vim.api.nvim_win_get_cursor(diagnostics.window)
      local location = ranges[_cursor[1]]
      if location then
        location[1] = location[1] + 1
        vim.api.nvim_win_set_cursor(source_win, location)
        vim.api.nvim_set_current_win(source_win)
        diagnostics.close()
      end
    end,
  })

  vim.api.nvim_buf_set_keymap(diagnostics.buffer, "n", "q", "", {
    desc = "Exit diagnostics window",
    callback = function ()
      pcall(vim.api.nvim_set_current_win, source_win)
      diagnostics.close()
    end,
  })
end

------------------------------------------------------------------------------
-- Module Exports
------------------------------------------------------------------------------

--- Triggers the diagnostic hover window for the current line.
---@param window? integer The target window ID (defaults to current window).
function diagnostics.hover(window)
  window = window or vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_win_get_buf(window)
  local cursor = vim.api.nvim_win_get_cursor(window)
  local items = vim.diagnostic.get(buffer, { lnum = cursor[1] - 1 })

  if #items == 0 then
    diagnostics.close()
    return vim.api.nvim_echo({
      { " diagnostics.lua ", "DiagnosticVirtualTextWarn" },
      { ": No diagnostic under cursor", "@comment" },
    }, true, {})
  elseif diagnostics.window and vim.api.nvim_win_is_valid(diagnostics.window) then
    return vim.api.nvim_set_current_win(diagnostics.window)
  end

  if diagnostics.quad then diagnostics.update_quad(diagnostics.quad, false) end
  if not diagnostics.buffer or not vim.api.nvim_buf_is_valid(diagnostics.buffer) then
    diagnostics.buffer = vim.api
      .nvim_create_buf(false, true)
  end

  vim.bo[diagnostics.buffer].ft = "markdown"
  vim.api.nvim_buf_clear_namespace(diagnostics.buffer, diagnostics.ns, 0, -1)

  local W, D, cursor_y, ranges, level = diagnostics.__build_buffer_state(items, cursor)
  diagnostics.__setup_window(window, W, D, cursor_y, level)
  diagnostics.__attach_keymaps(window, ranges)
end

--- Initializes the diagnostics plugin configuration and global autocmds.
---@param config? diagnostics.config Optional configuration table overrides.
function diagnostics.setup(config)
  if type(config) == "table" then
    diagnostics.config = vim.tbl_extend("force", diagnostics.config, config)

    if diagnostics.config.keymap then
      vim.api.nvim_set_keymap("n", diagnostics.config.keymap, "", {
        callback = diagnostics.hover,
        desc = "Open diagnostic hover",
      })
    end
  end
end

return diagnostics
