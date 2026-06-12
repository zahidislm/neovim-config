local api = vim.api
_G["Statusline"] = {}

---@class SeparatorConfig
---@field left  string
---@field right string

---@class ComponentConfig
---@field left  string[]
---@field right string[]

---@class ExclusionConfig
---@field filetypes string[]
---@field buftypes  string[]

---@class StatuslineConfig
---@field separators SeparatorConfig
---@field components ComponentConfig

---@type StatuslineConfig
_G.Statusline.config = {
  separators = { left = "", right = "" },
  components = {
    left = {
      "mode",
      "git",
      "diagnostic_error",
      "diagnostic_warn",
      "diagnostic_info",
      "diagnostic_hint",
    },
    right = { "macro", "lsp", "session", "filename", "search", "ruler" },
  },
}

---@param event_group integer
local function init(event_group)
  api.nvim_del_augroup_by_name("StatuslineLazyLoad")

  local highlight = require("ui.statusline.highlight")
  local render = require("ui.statusline.render")

  highlight.setup()
  local events = render.init()

  -- Dynamically wire up component events (ModeChanged, DiagnosticChanged, etc.)
  for event_name, _ in pairs(events) do
    -- Handle Neovim's "User" events differently than standard events
    local is_user = event_name:match("^User ")
    local actual_event = is_user and "User" or event_name
    local pattern = is_user and event_name:gsub("^User ", "") or nil

    api.nvim_create_autocmd(actual_event, {
      group = event_group,
      pattern = pattern,
      callback = function (args)
        render.on_event(args)
      end,
    })
  end

  _G.Statusline.eval = function () return render.evaluate() end

  vim.o.statusline = "%!v:lua.Statusline.eval()"
end

return { init = init }
