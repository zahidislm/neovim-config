local api = vim.api
local icons = vim.g.iconchars

local M = {}

local MODES = {
  n = { alias = " N ", hl = "StatusLineModeNormal" },
  no = { alias = " N ", hl = "StatusLineModeNormal" },
  nov = { alias = " N ", hl = "StatusLineModeNormal" },
  noV = { alias = " N ", hl = "StatusLineModeNormal" },
  ["no\x16"] = { alias = " N ", hl = "StatusLineModeNormal" },
  niI = { alias = " N ", hl = "StatusLineModeNormal" },
  niR = { alias = " N ", hl = "StatusLineModeNormal" },
  niV = { alias = " N ", hl = "StatusLineModeNormal" },
  nt = { alias = " N ", hl = "StatusLineModeNormal" },
  ntT = { alias = " N ", hl = "StatusLineModeNormal" },
  v = { alias = " V ", hl = "StatusLineModeVisual" },
  vs = { alias = " V ", hl = "StatusLineModeVisual" },
  V = { alias = " V ", hl = "StatusLineModeVisual" },
  Vs = { alias = " V ", hl = "StatusLineModeVisual" },
  ["\x16"] = { alias = " V ", hl = "StatusLineModeVisual" },
  ["\x16s"] = { alias = " V ", hl = "StatusLineModeVisual" },
  s = { alias = " S ", hl = "StatusLineModeVisual" },
  S = { alias = " S ", hl = "StatusLineModeVisual" },
  ["\x13"] = { alias = " S ", hl = "StatusLineModeVisual" },
  i = { alias = " I ", hl = "StatusLineModeInsert" },
  ic = { alias = " I ", hl = "StatusLineModeInsert" },
  ix = { alias = " I ", hl = "StatusLineModeInsert" },
  R = { alias = " R ", hl = "StatusLineModePending" },
  Rc = { alias = " R ", hl = "StatusLineModePending" },
  Rx = { alias = " R ", hl = "StatusLineModePending" },
  Rv = { alias = " R ", hl = "StatusLineModePending" },
  Rvc = { alias = " R ", hl = "StatusLineModePending" },
  Rvx = { alias = " R ", hl = "StatusLineModePending" },
  c = { alias = " C ", hl = "StatusLineModeCommand" },
  cv = { alias = " C ", hl = "StatusLineModeCommand" },
  ce = { alias = " C ", hl = "StatusLineModeCommand" },
  r = { alias = " R ", hl = "StatusLineModePending" },
  rm = { alias = " R ", hl = "StatusLineModePending" },
  ["r?"] = { alias = " R ", hl = "StatusLineModePending" },
  ["!"] = { alias = " T ", hl = "StatusLineModeCommand" },
  t = { alias = " T ", hl = "StatusLineModeCommand" },
}

local MODE_DEFAULT = MODES.n

local _ruler_str = icons.statusline.lines .. "%2L [%P]"
local _bookmark_str = icons.statusline.label .. " "
local _bm_cache = nil
local _bm_loaded = false

---@return table | nil
local function get_bm()
  if not _bm_loaded then
    local ok, mod = pcall(require, "bento.api")
    _bm_cache = ok and mod or nil
    _bm_loaded = true
  end
  return _bm_cache
end

---@class ComponentDef
---@field default?    string
---@field render      fun(args: table, winid: number): string
---@field resolve_hl? fun(winid: number): string
---@field condition?  fun(winid: number): boolean
---@field events      string[]
---@field hl?         string
---@field max_width?  number

---@type table<string, ComponentDef>
M.components = {
  mode = {
    default = " N ",
    render = function ()
      return (MODES[api.nvim_get_mode().mode] or MODE_DEFAULT).alias
    end,
    resolve_hl = function ()
      return (MODES[api.nvim_get_mode().mode] or MODE_DEFAULT).hl
    end,
    events = { "ModeChanged", "BufEnter" },
    hl = "StatusLineModeNormal",
  },
  ruler = {
    render = function () return _ruler_str end,
    events = { "BufEnter" },
    hl = "StatusLineRuler",
  },
  filename = {
    render = function (_, winid)
      local bufnr = api.nvim_win_get_buf(winid)
      local bm = get_bm()

      local icon = ""
      if bm and bm.is_locked(bufnr) then
        icon = _bookmark_str
      end

      local path = api.nvim_buf_get_name(bufnr)
      if path == "" then return icon .. "[No Name]" end

      local parent = vim.fn.fnamemodify(path, ":p:h:t")
      local tail = vim.fn.fnamemodify(path, ":t")
      return icon .. parent .. "/" .. tail
    end,
    -- Add
    resolve_hl = function (winid)
      local bufnr = api.nvim_win_get_buf(winid)
      local bm = get_bm()

      -- Priority 1: Unsaved changes
      if vim.bo[bufnr].modified then
        return "StatusLineFileModified"
      end

      -- Priority 2: Bookmarked file
      if bm and bm.is_locked(bufnr) then
        return "StatusLineFileBookmark"
      end

      -- Default
      return "StatusLineFile"
    end,
    events = { "BufModifiedSet", "BufEnter", "User BookmarkChanged", "BufFilePost" },
    max_width = 30,
  },
  git = {
    render = function (_, winid)
      local bufnr = api.nvim_win_get_buf(winid)
      return require("ui.statusline.providers.git_daemon").get_status(bufnr)
    end,
    condition = function (winid)
      return require("ui.statusline.providers.git_daemon")
        .is_in_git_repo(api.nvim_win_get_buf(winid))
    end,
    events = {
      "User GitSignsUpdate",
      "User MiniGitUpdated",
      "User MiniDiffUpdated",
      "User GitDaemonUpdate",
      "BufEnter",
      "BufWritePost",
    },
    hl = "StatusLineGit",
  },
  lsp = {
    render = function (_, winid)
      local bufnr = api.nvim_win_get_buf(winid)
      local names = {}
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        names[#names + 1] = client.name
      end
      return table.concat(names, "|")
    end,
    condition = function (winid)
      local bufnr = api.nvim_win_get_buf(winid)
      return api.nvim_buf_is_valid(bufnr) and #vim.lsp.get_clients({ bufnr = bufnr }) > 0
    end,
    events = { "LspAttach", "LspDetach" },
    hl = "StatusLineLSP",
    max_width = 20,
  },
  macro = {
    render = function (args)
      if args.event == "RecordingLeave" then return "" end
      local reg = vim.fn.reg_recording()
      return reg ~= "" and ("@" .. reg) or ""
    end,
    events = { "RecordingEnter", "RecordingLeave" },
    hl = "StatusLineMacro",
  },
  session = {
    render = function ()
      local session = vim.v.this_session
      if session == "" then return "" end
      local name = vim.fn.fnamemodify(session, ":t")
      return name == "" and "" or icons.statusline.session .. name
    end,
    condition = function () return vim.v.this_session ~= "" end,
    events = { "BufEnter" },
    hl = "StatusLineSession",
    max_width = 20,
  },
  search = {
    render = function ()
      if vim.v.hlsearch == 0 then return "" end
      local ok, count = pcall(vim.fn.searchcount, { recompute = true, maxcount = 999 })
      if not ok or type(count) ~= "table" or not count.total or count.total == 0 then
        return ""
      end

      local current = count.current == 0 and 1 or count.current
      return string.format("[%d/%d]", current, count.total)
    end,
    events = { "CmdlineLeave", "CursorHold" },
    hl = "StatusLineSearch",
  },
}

local diag_levels = {
  {
    key = "error",
    severity = vim.diagnostic.severity.ERROR,
    icon = icons.diagnostics.Error,
    hl = "StatusLineDiagnosticError",
  },
  {
    key = "warn",
    severity = vim.diagnostic.severity.WARN,
    icon = icons.diagnostics.Warn,
    hl = "StatusLineDiagnosticWarn",
  },
  {
    key = "info",
    severity = vim.diagnostic.severity.INFO,
    icon = icons.diagnostics.Info,
    hl = "StatusLineDiagnosticInfo",
  },
  {
    key = "hint",
    severity = vim.diagnostic.severity.HINT,
    icon = icons.diagnostics.Hint,
    hl = "StatusLineDiagnosticHint",
  },
}

for _, level in ipairs(diag_levels) do
  local sev = level.severity
  local icon = level.icon
  M.components["diagnostic_" .. level.key] = {
    render = function (_, winid)
      local bufnr = api.nvim_win_get_buf(winid)
      if not api.nvim_buf_is_valid(bufnr) then return "" end
      local counts = vim.diagnostic.count(bufnr, { severity = sev })
      local n = counts[sev] or 0
      return n > 0 and (icon .. n) or ""
    end,
    events = { "DiagnosticChanged", "BufEnter" },
    hl = level.hl,
  }
end

return M
