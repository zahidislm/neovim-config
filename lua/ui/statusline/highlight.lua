local api = vim.api
local cache = require("ui.statusline.cache")

local Highlight = {}

---@return table
local function get_palette()
  if vim.o.background == "dark" then
    return {
      fg = "#ebeef5",
      blue = "#005078",
      cyan = "#007676",
      green = "#015825",
      grey1 = "#0a0b10",
      grey2 = "#1c1d23",
      grey3 = "#2c2e33",
      grey4 = "#4f5258",
      magenta = "#4c0049",
      red = "#5e0009",
      yellow = "#6e5600",
    }
  else
    return {
      fg = "#0a0b10",
      blue = "#9fd8ff",
      cyan = "#83efef",
      green = "#aaedb7",
      grey1 = "#ebeef5",
      grey2 = "#d7dae1",
      grey3 = "#c4c6cd",
      grey4 = "#9b9ea4",
      magenta = "#ffc3fa",
      red = "#ffbcb5",
      yellow = "#f4d88c",
    }
  end
end

---@param p table
---@return table<string, table>
local function build_highlights(p)
  return {
    StatusLine = { bg = "NONE" },
    StatusLineModeNormal = { fg = p.fg, bg = p.magenta },
    StatusLineModeInsert = { fg = p.fg, bg = p.green },
    StatusLineModeVisual = { fg = p.fg, bg = p.cyan },
    StatusLineModeCommand = { fg = p.fg, bg = p.red },
    StatusLineModePending = { fg = p.fg, bg = p.yellow },
    StatusLineGit = { fg = p.fg, bg = p.grey3 },
    StatusLineGitAdd = { fg = p.green, bg = p.grey3 },
    StatusLineGitChange = { fg = p.yellow, bg = p.grey3 },
    StatusLineGitDelete = { fg = p.red, bg = p.grey3 },
    StatusLineDiagnosticError = { fg = p.fg, bg = p.red },
    StatusLineDiagnosticWarn = { fg = p.fg, bg = p.yellow },
    StatusLineDiagnosticInfo = { fg = p.fg, bg = p.blue },
    StatusLineDiagnosticHint = { fg = p.fg, bg = p.cyan },
    StatusLineFile = { fg = p.fg, bg = p.grey3 },
    StatusLineFileBookmark = { fg = p.fg, bg = p.yellow },
    StatusLineFileModified = { fg = p.fg, bg = p.green },
    StatusLineLSP = { fg = p.fg, bg = p.grey3 },
    StatusLineRuler = { fg = p.fg, bg = p.grey2 },
    StatusLineMacro = { fg = p.fg, bg = p.grey3 },
    StatusLineSession = { fg = p.fg, bg = p.grey3 },
    StatusLineSearch = { fg = p.fg, bg = p.grey3 },
  }
end

--- Extracts a specific color attribute from a highlight group.
---@param hl_name  string             The name of the highlight group
---@param attr     "fg" | "bg" | "sp" The attribute to extract
---@param fallback string             Fallback hex color if the attribute is absent
---@return string
function Highlight.get_color(hl_name, attr, fallback)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = hl_name, link = false })
  local color = ok and hl and hl[attr]

  if color then
    return type(color) == "number" and string.format("#%06x", color) or color
  end
  return fallback
end

--- Shared helper to build/update a separator highlight.
---@param parent_hl      string
---@param statusline_bg? string Optional: Passed in bulk updates to save API calls
local function apply_separator_hl(parent_hl, statusline_bg)
  statusline_bg = statusline_bg or Highlight.get_color("StatusLine", "bg", "NONE")
  local component_bg = Highlight.get_color(parent_hl, "bg", Highlight.palette.grey4)

  api.nvim_set_hl(0, "StatusLineSep_" .. parent_hl, {
    fg = component_bg,
    bg = statusline_bg,
  })
end

function Highlight.get_separator_hl(parent_hl)
  local sep_hl_name = "StatusLineSep_" .. parent_hl

  if cache.sep_hl[parent_hl] == nil then
    apply_separator_hl(parent_hl)
    cache.sep_hl[parent_hl] = true
  end
  return sep_hl_name
end

function Highlight.setup()
  Highlight.palette = get_palette()

  for hl_name, style in pairs(build_highlights(Highlight.palette)) do
    local opts = vim.tbl_extend("keep", style, { default = true })
    api.nvim_set_hl(0, hl_name, opts)
  end
end

function Highlight.on_colorscheme()
  Highlight.setup()
  vim.defer_fn(function ()
    cache.sep_hl = {}
    cache.clear_all_wins()
    vim.cmd.redrawstatus()
  end, 67)
end

return Highlight
