local api = vim.api
local cache = require("ui.statusline.cache")
local icons = vim.g.iconchars

local M = {}

local branch_status_hls = {
  ["local"] = "StatusLineGitDelete",
  ahead = "StatusLineGitAdd",
  behind = "StatusLineGitChange",
  diverged = "StatusLineGitChange",
}

local icon_add = (icons.git and icons.git.LineAdded) or "+"
local icon_mod = (icons.git and icons.git.LineModified) or "~"
local icon_del = (icons.git and icons.git.LineRemoved) or "-"
local icon_branch = (icons.git and icons.git.Branch) or ""

--- Formats a git branch string with optional diff counts
---@param branch?        string
---@param added?         number
---@param changed?       number
---@param removed?       number
---@param branch_status? "local" | "ahead" | "behind" | "diverged"
---@return string | nil
local function format_git(branch, added, changed, removed, branch_status)
  if not branch or branch == "" then return nil end

  local max_branch_len = 25
  if #branch > max_branch_len then
    branch = string.sub(branch, 1, max_branch_len - 1) .. "…"
  end

  local diffs = ""
  if added and added > 0 then
    diffs = diffs .. " %#StatusLineGitAdd#" .. icon_add .. " %#StatusLineGit#" .. added
  end

  if changed and changed > 0 then
    diffs = diffs .. " %#StatusLineGitChange#" .. icon_mod .. " %#StatusLineGit#" .. changed
  end

  if removed and removed > 0 then
    diffs = diffs .. " %#StatusLineGitDelete#" .. icon_del .. " %#StatusLineGit#" .. removed
  end

  local branch_hl = branch_status_hls[branch_status]
  icon_branch = branch_hl and ("%#" .. branch_hl .. "#" .. icon_branch .. "%#StatusLineGit#")
    or icon_branch

  return icon_branch .. " " .. branch .. diffs
end

--- Resolves a raw path returned by finddir(".git", ...) to a .git path
---@param raw string The relative-or-absolute path returned by finddir
---@return string Absolute path to .git, no trailing slash
local function resolve_git_dir(raw)
  local path = vim.fn.fnamemodify(raw, ":p"):gsub("/$", "")
  local stat = vim.uv.fs_stat(path)

  -- If .git is a file (worktree/submodule), parse the `gitdir: <path>` pointer
  if stat and stat.type == "file" then
    local f = io.open(path, "r")
    if f then
      local content = f:read("*l") or ""
      f:close()

      local gitdir = content:match("^gitdir:%s*(.*)$")
      if gitdir then
        -- Handle both relative paths (submodules) and absolute paths (worktrees)
        local is_absolute = gitdir:sub(1, 1) == "/" or gitdir:match("^%a:")
        if not is_absolute then
          local parent_dir = vim.fn.fnamemodify(path, ":h")
          gitdir = parent_dir .. "/" .. gitdir
        end
        return vim.fn.fnamemodify(gitdir, ":p"):gsub("/$", "")
      end
    end
  end

  return path
end

--- Reads the current git branch from the HEAD file
---@param git_dir string
---@return string
local function read_head(git_dir)
  local f = io.open(git_dir .. "/HEAD")
  if not f then return "" end
  local head = f:read()
  f:close()
  return head:match("ref: refs/heads/(.+)$") or head:sub(1, 7)
end

local watchers = {}

--- Watches the HEAD file for changes and triggers GitDaemonUpdate autocmd
---@param git_dir string
local function watch_head(git_dir)
  if watchers[git_dir] then return end
  local w = vim.uv.new_fs_event()
  vim.uv.unref(w)
  watchers[git_dir] = w
  w:start(
    git_dir .. "/HEAD", {},
    vim.schedule_wrap(function ()
      api.nvim_exec_autocmds("User", { pattern = "GitDaemonUpdate", modeline = false })
    end)
  )
end

---@type table<string, boolean>
local pending_remote = {}

--- Parses `for-each-ref`'s `%(upstream:short)` / `%(upstream:track)` pair.
---@param upstream string
---@param track    string
---@return "local" | "ahead" | "behind" | "diverged" | nil
local function parse_remote_status(upstream, track)
  if upstream == "" or track == "[gone]" then return "local" end

  local ahead = track:find("ahead", 1, true) ~= nil
  local behind = track:find("behind", 1, true) ~= nil

  if ahead and behind then return "diverged" end
  if ahead then return "ahead" end
  if behind then return "behind" end

  return nil
end

--- Checks a branch's status against its last-fetched upstream
---@param git_dir string
---@param branch  string
local function refresh_remote_status(git_dir, branch)
  local key = git_dir .. "\0" .. branch
  if pending_remote[key] then return end
  pending_remote[key] = true

  vim.system({
    "git",
    "--git-dir=" .. git_dir,
    "for-each-ref",
    "--format=%(upstream:short)%09%(upstream:track)",
    "refs/heads/" .. branch,
  },
    { text = true }, vim.schedule_wrap(function (res)
      pending_remote[key] = nil
      if res.code ~= 0 then return end

      local upstream, track = (res.stdout or ""):match("^([^\t]*)\t?(.-)%s*$")
      if not upstream then return end

      local status = parse_remote_status(upstream, track)
      if cache.git_remote[key] ~= status then
        cache.git_remote[key] = status
        api.nvim_exec_autocmds("User", { pattern = "GitDaemonUpdate", modeline = false })
      end
    end))
end

--- Gets the diff counts for a buffer using gitsigns or mini.diff
---@param bufnr integer
---@return number|nil, number|nil, number|nil
local function get_diff_counts(bufnr)
  if package.loaded["gitsigns"] then
    local ok, d = pcall(api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
    if ok and d then return d.added, d.changed, d.removed end
  end

  if package.loaded["mini.diff"] then
    local ok, d = pcall(api.nvim_buf_get_var, bufnr, "minidiff_summary")
    if ok and d then return d.add, d.change, d.delete end
  end
end

--- Checks if a buffer is in a git repository
---@param bufnr integer
---@return boolean
function M.is_in_git_repo(bufnr)
  local bt = vim.bo[bufnr].buftype
  if bt == "nofile" or bt == "terminal" or bt == "prompt" then
    return false
  end

  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then return false end

  local dir = vim.fn.fnamemodify(name, ":p:h")
  local cached = cache.repo[dir]
  if cached ~= nil then return cached ~= false end

  -- Locate '.git' as either a directory or a file
  local match = vim.fs.find(".git", { path = dir, upward = true })[1]

  if not match then
    cache.repo[dir] = false
    return false
  end

  local git_dir = resolve_git_dir(match)
  cache.repo[dir] = git_dir
  watch_head(git_dir)
  return true
end

--- Gets the status of a buffer in a git repository
---@param bufnr integer
---@return string
function M.get_status(bufnr)
  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then return "" end

  local dir = vim.fn.fnamemodify(name, ":p:h")
  local git_dir = cache.repo[dir]
  if type(git_dir) ~= "string" then return "" end -- not in a repo

  local branch = read_head(git_dir)
  local added, changed, removed = get_diff_counts(bufnr)

  if branch == "" and package.loaded["mini.git"] then
    local ok, s = pcall(api.nvim_buf_get_var, bufnr, "minigit_summary")
    if ok and s then branch = s.head_name or "" end
  end

  local branch_status
  if branch ~= "" then
    branch_status = cache.git_remote[git_dir .. "\0" .. branch]
    refresh_remote_status(git_dir, branch)
  end

  return format_git(branch, added, changed, removed, branch_status) or ""
end

--- stop the watchers and free the handles
function M.stop_watchers()
  for git_dir, w in pairs(watchers) do
    w:stop()
    watchers[git_dir] = nil
  end
end

return M
