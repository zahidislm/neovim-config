--[[────────────────────────────────────────────────────────────────────────────
cache.lua | Centralized cache management
───────────────────────────────────────────────────────────────────────────]]

local M = {}
local table_clear = require("table.clear")

-- ─────────────────────────────────────────────────────────────────────────────
-- Named Caches  ·  git_daemon.lua
-- ─────────────────────────────────────────────────────────────────────────────

--- Absolute directory path → boolean.
--- Whether that directory is inside a git repository.
--- Persists for the lifetime of the session; cleared on DirChanged.
---@type table<string, boolean | string>
M.repo = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Named Caches  ·  highlight.lua
-- ─────────────────────────────────────────────────────────────────────────────

--- parent_hl_name → true.
--- Guards against re-creating separator highlights that already exist.
--- Entries are regenerated (overwritten) on ColorScheme.
---@type table<string, boolean>
M.sep_hl = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Named Caches  ·  render.lua
-- ─────────────────────────────────────────────────────────────────────────────

--- winid → WindowState { values, pills, final_string }.
--- The render engine's per-window component value and pill cache.
--- Entries are modified in-place by on_event(); cleared on WinClosed.
---@type table<number, table>
M.win = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Bulk Invalidation Helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Drops window-scoped state for a given window.
--- Intended for WinClosed autocmd.
---@param winid number
function M.clear_win(winid)
  M.win[winid] = nil
end

--- Drops state for all windows
function M.clear_all_wins()
  for k in pairs(M.win) do
    M.win[k] = nil
  end
end

--- Empties all session-level caches without reallocating tables (GC friendly).
--- Intended for DirChanged, where every repo and git-status assumption is stale.
function M.clear_session()
  table_clear(M.repo)
  table_clear(M.win)
end

return M
