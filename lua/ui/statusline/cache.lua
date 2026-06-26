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

--- hl_name → style table { fg, bg, ... }.
--- Saved during setup so highlights can be faithfully restored after a
--- ColorScheme event without re-running the full setup() call.
---@type table<string, table>
M.saved_hl = {}

--- Synthesised hl_name → mini.icons bg hex string.
--- Lets resolve_hl() skip nvim_set_hl on repeat visits for the same file type.
--- Entries are updated (not cleared) on ColorScheme to match the new base fg.
---@type table<string, string>
M.file_hl = {}

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
