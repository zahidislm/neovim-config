-- ============================================================================
-- Minimalistic vim.pack UI
-- Provides :Pack command that opens a floating window dashboard
-- for managing plugins (update, clean, log, inspect).
-- ============================================================================

local PackUI = {}
local api = vim.api
local ns = api.nvim_create_namespace("pack_ui")

-- ============================================================================
-- Type Definitions & Config
-- ============================================================================

---@class PackUiConfig
---@field max_commits_preview? integer
---@field border?              string | string[]
---@field keymaps?             table<string, string | string[]>

---@class PackPluginSpec
---@field name     string
---@field src?     string
---@field version? string | number

---@class PackPlugin
---@field spec   PackPluginSpec
---@field active boolean
---@field path   string
---@field rev?   string

---@class PackUiState
---@field bufnr?              integer
---@field winid?              integer
---@field win_autocmd_id?     integer
---@field line_to_plugin      table<integer, string>
---@field plugin_lines        table<string, integer>
---@field expanded            table<string, boolean>
---@field show_help           boolean
---@field updates             table<string, string[]>
---@field breaking            table<string, boolean>
---@field unreleased_breaking table<string, string[]>
---@field show_all_commits    table<string, boolean>
---@field latest_ref          table<string, string>
---@field checking            boolean
---@field check_id            integer

---@class VersionCheckResult
---@field name                 string
---@field updates?             string[]
---@field breaking?            boolean
---@field unreleased_breaking? string[]
---@field latest_ref?          string

-- Default Configuration
local config = {
  max_commits_preview = 10,
  border = "rounded",
  keymaps = {
    close = { "q", "<Esc>" },
    update_all = "U",
    update_plugin = "u",
    check_updates = "C",
    show_help = "?",
    next_plugin = "]]",
    prev_plugin = "[[",
    open_log = "L",
    clean_plugins = "X",
    delete_plugin = "D",
    toggle_details = "<CR>",
  },
}

-- Transient UI state
---@type PackUiState
local state = {
  bufnr = nil,
  winid = nil,
  win_autocmd_id = nil,
  line_to_plugin = {},
  plugin_lines = {},
  expanded = {},
  show_help = false,
  updates = {},
  breaking = {},
  unreleased_breaking = {},
  show_all_commits = {},
  latest_ref = {},
  checking = false,
  check_id = 0,
}

-- Session Caches
---@type table<string, string | boolean>
local tag_cache = {}
---@type table<string, string | boolean>
local ref_cache = {}

-- ============================================================================
-- Highlight Setup
-- ============================================================================

local function setup_highlights()
  local links = {
    PackUiHeader = "Title",
    PackUiButton = "Function",
    PackUiPluginLoaded = "String",
    PackUiPluginNotLoaded = "Comment",
    PackUiPluginMissing = "ErrorMsg",
    PackUiUpdateAvailable = "DiagnosticInfo",
    PackUiBreaking = "DiagnosticWarn",
    PackUiVersion = "Number",
    PackUiSectionHeader = "Label",
    PackUiSeparator = "FloatBorder",
    PackUiDetail = "Comment",
    PackUiHelp = "SpecialComment",
  }
  for group, target in pairs(links) do
    api.nvim_set_hl(0, group, { link = target, default = true })
  end
end

-- ============================================================================
-- Utility & SemVer Functions
-- ============================================================================

---@param action string
---@return string
local function get_primary_key(action)
  local keys = config.keymaps[action]
  return type(keys) == "table" and (keys[1] or "") or (keys or "")
end

---@param p PackPlugin
---@return string
local function get_version_str(p)
  local v = p.spec.version
  return (v == nil and "") or (type(v) == "string" and v) or tostring(v)
end

---@param tag? string
---@return integer[]? {major, minor, patch}
local function parse_semver(tag)
  if not tag then return nil end
  local major, minor, patch = tag:match("^v?(%d+)%.(%d+)%.(%d+)")
  if major then return { tonumber(major), tonumber(minor), tonumber(patch) } end
  return nil
end

---@param a integer[]
---@param b integer[]
---@return boolean
local function semver_gt(a, b)
  if not a or not b then return false end
  if a[1] ~= b[1] then return a[1] > b[1] end
  if a[2] ~= b[2] then return a[2] > b[2] end
  return a[3] > b[3]
end

---@param stdout? string
---@return string[]
local function parse_commits(stdout)
  local commits = {}
  if stdout and stdout ~= "" then
    for line in stdout:gmatch("[^\n]+") do
      commits[#commits + 1] = line
    end
  end
  return commits
end

---@param c string
---@return boolean
local function is_breaking_commit(c)
  return c:match("%x+ %w+!:") ~= nil or c:match("%x+ %w+%b()!:") ~= nil
end

---@param commits string[]
---@return boolean
local function has_breaking_commit(commits)
  for i = 1, #commits do
    if is_breaking_commit(commits[i]) then return true end
  end
  return false
end

---@param commits string[]
---@return string[]
local function filter_breaking(commits)
  local breaking = {}
  for i = 1, #commits do
    if is_breaking_commit(commits[i]) then breaking[#breaking + 1] = commits[i] end
  end
  return breaking
end

-- ============================================================================
-- Git Integration
-- ============================================================================

---@param path string
---@return string?
local function get_installed_tag(path)
  if not path then return nil end
  if tag_cache[path] ~= nil then return tag_cache[path] or nil end

  local result = vim.system(
    { "git", "-C", path, "describe", "--tags", "--exact-match", "HEAD" },
    {
      text = true,
    }
  ):wait()
  local tag = result.code == 0 and vim.trim(result.stdout) or false
  tag_cache[path] = tag
  return tag or nil
end

---@param path     string
---@param range    string
---@param callback fun(commits: string[])
local function git_log(path, range, callback)
  vim.system({ "git", "-C", path, "log", "--oneline", range }, { text = true }, function (res)
    callback(parse_commits(res.code == 0 and res.stdout or ""))
  end)
end

---@param path     string
---@param callback fun(ref: string?)
local function resolve_remote_ref(path, callback)
  if ref_cache[path] ~= nil then return callback(ref_cache[path] or nil) end

  vim.system(
    { "git", "-C", path, "symbolic-ref", "refs/remotes/origin/HEAD" },
    { text = true },
    function (result)
      if result.code == 0 then
        local ref = vim.trim(result.stdout)
        ref_cache[path] = ref
        return callback(ref)
      end

      local function check_branch(branch, next_cb)
        vim.system(
          { "git", "-C", path, "rev-parse", "--verify", branch },
          { text = true },
          function (r)
            if r.code == 0 then
              ref_cache[path] = branch
              callback(branch)
            else
              next_cb()
            end
          end
        )
      end

      check_branch("origin/main", function ()
        check_branch("origin/master", function ()
          ref_cache[path] = false
          callback(nil)
        end)
      end)
    end
  )
end

-- ============================================================================
-- UI Rendering Logic
-- ============================================================================

---@return string[], table[]
local function build_content()
  ---@type PackPlugin[]
  local plugins = vim.pack.get(nil, { info = false })
  local loaded, not_loaded = {}, {}

  for i = 1, #plugins do
    if plugins[i].spec.name then
      if plugins[i].active then
        loaded[#loaded + 1] = plugins[i]
      else
        not_loaded[#not_loaded + 1] = plugins[i]
      end
    end
  end

  table.sort(loaded, function (a, b) return a.spec.name < b.spec.name end)
  table.sort(not_loaded, function (a, b) return a.spec.name < b.spec.name end)

  local lines, hls = {}, {}
  local line_to_plugin, plugin_lines = {}, {}

  local function add(text, hl)
    local lnum = #lines
    lines[lnum + 1] = text
    if hl then
      hls[#hls + 1] = { lnum, 0, #text, hl }
    end
  end

  local function add_hl(lnum, col_start, col_end, hl)
    hls[#hls + 1] = { lnum, col_start, col_end, hl }
  end

  local status = state.checking and "  (checking...)" or ""
  add(
    string.format(" vim.pack -- %d plugins | %d loaded%s", #plugins, #loaded, status),
    "PackUiHeader"
  )
  local win_width = state.winid and api.nvim_win_get_width(state.winid) or 80
  add(" " .. string.rep("─", win_width - 1), "PackUiSeparator")

  local bar = string.format(
    " [%s] Update All  [%s] Update  [%s] Check  [%s] Clean  [%s] Delete  [%s] Log  [%s] Help",
    get_primary_key("update_all"), get_primary_key("update_plugin"),
    get_primary_key("check_updates"), get_primary_key("clean_plugins"),
    get_primary_key("delete_plugin"), get_primary_key("open_log"), get_primary_key("show_help")
  )
  add(bar)
  local lnum = #lines - 1
  for s, e in bar:gmatch("()%[.-%]()") do
    add_hl(lnum, s - 1, e - 1, "PackUiButton")
  end

  if state.show_help then
    local function k(action)
      return get_primary_key(action)
    end
    add("")
    add(" Keymaps:", "PackUiHelp")
    add(string.format("   %-7s Update all plugins", k("update_all")), "PackUiHelp")
    add(string.format("   %-7s Update plugin under cursor", k("update_plugin")), "PackUiHelp")
    add(string.format("   %-7s Check remote for new commits", k("check_updates")), "PackUiHelp")
    add(string.format("   %-7s Clean non-active plugins", k("clean_plugins")), "PackUiHelp")
    add(
      string.format("   %-7s Delete plugin under cursor (non-active only)", k("delete_plugin")),
      "PackUiHelp"
    )
    add(string.format("   %-7s Open update log file", k("open_log")), "PackUiHelp")
    add(string.format("   %-7s Toggle plugin details", k("toggle_details")), "PackUiHelp")
    add(string.format(
        "   %-7s Jump to next/prev plugin",
        k("next_plugin") .. "/"
          .. k("prev_plugin")
      ), "PackUiHelp")
    add(string.format("   %-7s Close window", k("close")), "PackUiHelp")
  end

  local max_name = 0
  for i = 1, #plugins do
    max_name = math.max(max_name, #(plugins[i].spec.name or ""))
  end

  ---@param p        PackPlugin
  ---@param icon     string
  ---@param hl_group string
  local function render_plugin(p, icon, hl_group)
    local name = p.spec.name
    local pad = string.rep(" ", max_name - #name + 2)
    local version = get_version_str(p)
    local tag = p.spec.version and get_installed_tag(p.path) or nil
    local rev_short = p.rev and p.rev:sub(1, 7) or ""

    local ver_display = tag or (rev_short ~= "" and rev_short or version)
    local latest = state.latest_ref[name]

    if latest then
      local cur_has_v, new_has_v = ver_display:match("^v") ~= nil, latest:match("^v") ~= nil
      local latest_display = latest
      if cur_has_v and not new_has_v then
        latest_display = "v" .. latest
      elseif not cur_has_v and new_has_v then
        latest_display = latest:sub(2)
      end
      if latest_display ~= ver_display then
        ver_display = ver_display .. " → " .. latest_display
      end
    end

    local update_count = state.updates[name] and #state.updates[name] or 0
    local update_str = update_count > 0 and string.format("  ↑%d", update_count) or ""
    local unreleased = state.unreleased_breaking[name]
    local unreleased_str = (unreleased and #unreleased > 0)
      and string.format("  ⚠ %d breaking unreleased", #unreleased)
      or ""

    local line = string.format(
      "   %s %s%s%s%s%s", icon, name, pad, ver_display, update_str, unreleased_str
    )
    local lnum_cur = #lines
    add(line)

    local name_start = 3 + #icon + 1
    add_hl(lnum_cur, 3, 3 + #icon, hl_group)
    add_hl(lnum_cur, name_start, name_start + #name, hl_group)

    if #ver_display > 0 then
      local ver_start = name_start + #name + #pad
      add_hl(
        lnum_cur, ver_start, ver_start + #ver_display,
        state.breaking[name] and "PackUiBreaking" or "PackUiVersion"
      )
    end

    if update_count > 0 then
      local update_start = name_start + #name + #pad + #ver_display
      add_hl(
        lnum_cur, update_start, update_start + #update_str,
        state.breaking[name] and "PackUiBreaking" or "PackUiUpdateAvailable"
      )
    end

    if #unreleased_str > 0 then
      local unrel_start = name_start + #name + #pad + #ver_display + #update_str
      add_hl(lnum_cur, unrel_start, unrel_start + #unreleased_str, "PackUiBreaking")
    end

    line_to_plugin[lnum_cur + 1], plugin_lines[name] = name, lnum_cur + 1

    if state.expanded[name] then
      add(string.format("     Path:    %s", p.path), "PackUiDetail")
      line_to_plugin[#lines] = name
      add(string.format("     Source:  %s", p.spec.src or "Local/Unknown"), "PackUiDetail")
      line_to_plugin[#lines] = name
      if p.rev then
        add(string.format("     Rev:     %s", p.rev), "PackUiDetail")
        line_to_plugin[#lines] = name
      end

      local commits = state.updates[name]
      if commits and #commits > 0 then
        local max_commits = state.show_all_commits[name] and #commits or config.max_commits_preview
        for i, c in ipairs(commits) do
          if i > max_commits then
            add(
              string.format("     ... and %d more (Enter to expand)", #commits - max_commits),
              "PackUiDetail"
            )
            line_to_plugin[#lines] = name
            break
          end
          add("     " .. c, is_breaking_commit(c) and "PackUiBreaking" or nil)
          line_to_plugin[#lines] = name
        end
        add("")
      end

      if unreleased and #unreleased > 0 then
        add(
          string.format("     ⚠ %d breaking change(s) unreleased on main:", #unreleased),
          "PackUiBreaking"
        )
        line_to_plugin[#lines] = name
        for _, c in ipairs(unreleased) do
          add("       " .. c, "PackUiBreaking")
          line_to_plugin[#lines] = name
        end
        add("")
      end
    end
  end

  add("")
  add(string.format(" Loaded (%d)", #loaded), "PackUiSectionHeader")
  for i = 1, #loaded do
    render_plugin(loaded[i], "●", "PackUiPluginLoaded")
  end

  if #not_loaded > 0 then
    add("")
    add(string.format(" Not Loaded (%d)", #not_loaded), "PackUiSectionHeader")
    for i = 1, #not_loaded do
      render_plugin(not_loaded[i], "○", "PackUiPluginNotLoaded")
    end
  end

  state.line_to_plugin, state.plugin_lines = line_to_plugin, plugin_lines
  return lines, hls
end

local function render()
  if not state.bufnr or not api.nvim_buf_is_valid(state.bufnr) then return end
  local lines, hls = build_content()

  vim.bo[state.bufnr].modifiable = true
  api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].modified = false

  api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
  for i = 1, #hls do
    local hl = hls[i]
    api.nvim_buf_set_extmark(state.bufnr, ns, hl[1], hl[2], { end_col = hl[3], hl_group = hl[4] })
  end
end

-- ============================================================================
-- Update Checking Logic
-- ============================================================================

---@param name        string
---@param path        string
---@param current_tag string
---@param finish_cb   fun(res: VersionCheckResult)
local function process_versioned_plugin(name, path, current_tag, finish_cb)
  vim.system(
    { "git", "-C", path, "tag", "--list", "--sort=-version:refname" },
    { text = true },
    function (tag_res)
      local cur_ver = parse_semver(current_tag)
      local latest_tag, latest_ver = nil, nil

      if tag_res.code == 0 then
        for t in tag_res.stdout:gmatch("[^\n]+") do
          local v = parse_semver(t)
          if v and (not latest_ver or semver_gt(v, latest_ver)) then
            latest_tag, latest_ver = t, v
          end
        end
      end

      local result = { name = name } --[[@as VersionCheckResult]]
      if cur_ver and latest_ver and latest_ver[1] > cur_ver[1] then result.breaking = true end

      local function check_unreleased()
        resolve_remote_ref(path, function (ref)
          if not ref then return finish_cb(result) end
          local compare_from = latest_tag or current_tag
          git_log(path, compare_from .. ".." .. ref, function (unreleased)
            local breaking_lines = filter_breaking(unreleased)
            if #breaking_lines > 0 then result.unreleased_breaking = breaking_lines end
            finish_cb(result)
          end)
        end)
      end

      if cur_ver and latest_ver and semver_gt(latest_ver, cur_ver) and latest_tag then
        result.latest_ref = latest_tag
        git_log(path, "HEAD.." .. latest_tag, function (commits)
          result.updates = commits
          if has_breaking_commit(commits) then result.breaking = true end
          check_unreleased()
        end)
      else
        result.updates = {}
        check_unreleased()
      end
    end
  )
end

---@param name      string
---@param path      string
---@param finish_cb fun(res: VersionCheckResult?)
local function process_unversioned_plugin(name, path, finish_cb)
  resolve_remote_ref(path, function (ref)
    if not ref then return finish_cb(nil) end
    git_log(path, "HEAD.." .. ref, function (commits)
      local result = { name = name, updates = commits } --[[@as VersionCheckResult]]
      if has_breaking_commit(commits) then result.breaking = true end
      if #commits > 0 then
        local latest_hash = commits[1]:match("^(%x+)")
        if latest_hash then result.latest_ref = latest_hash end
      end
      finish_cb(result)
    end)
  end)
end

--- Fetch all plugins and check for new commits on the remote
function PackUI.check_updates()
  if state.checking then return end

  ---@type PackPlugin[]
  local plugins = vim.pack.get(nil, { info = false })
  if #plugins == 0 then return end

  state.check_id = state.check_id + 1
  local my_check_id = state.check_id
  state.checking = true
  state.updates, state.breaking, state.unreleased_breaking, state.latest_ref = {}, {}, {}, {}
  render()

  local remaining = #plugins

  ---@param result VersionCheckResult?
  local function finish_one(result)
    vim.schedule(function ()
      if state.check_id ~= my_check_id then return end
      if result then
        if result.updates then state.updates[result.name] = result.updates end
        if result.breaking then state.breaking[result.name] = true end
        if result.unreleased_breaking then
          state.unreleased_breaking[result.name] = result.unreleased_breaking
        end
        if result.latest_ref then state.latest_ref[result.name] = result.latest_ref end
      end

      remaining = remaining - 1
      if remaining == 0 then
        state.checking = false
        render()
      end
    end)
  end

  for i = 1, #plugins do
    local p = plugins[i]
    if not p.spec.name or not p.path then
      finish_one(nil)
    else
      local current_tag = p.spec.version and get_installed_tag(p.path) or nil

      vim.system({ "git", "-C", p.path, "fetch", "--quiet", "--tags" }, {}, function (fetch_res)
        if fetch_res.code ~= 0 then return finish_one(nil) end

        if current_tag then
          process_versioned_plugin(p.spec.name, p.path, current_tag, finish_one)
        else
          process_unversioned_plugin(p.spec.name, p.path, finish_one)
        end
      end)
    end
  end
end

-- ============================================================================
-- Window & Keymap Management
-- ============================================================================

---@return string? plugin_name
local function plugin_at_cursor()
  if not state.winid or not api.nvim_win_is_valid(state.winid) then return nil end
  return state.line_to_plugin[api.nvim_win_get_cursor(state.winid)[1]]
end

local function reset_state()
  state.winid, state.bufnr = nil, nil
  state.expanded, state.show_all_commits, state.updates = {}, {}, {}
  state.breaking, state.unreleased_breaking, state.latest_ref = {}, {}, {}
  state.show_help, state.checking = false, false
  state.check_id = state.check_id + 1
end

function PackUI.close()
  if state.win_autocmd_id then
    pcall(api.nvim_del_autocmd, state.win_autocmd_id)
    state.win_autocmd_id = nil
  end
  if state.winid and api.nvim_win_is_valid(state.winid) then
    api.nvim_win_close(state.winid, true)
  end
  reset_state()
end

---@param direction 1 | - 1
local function jump_plugin(direction)
  if not state.winid or not api.nvim_win_is_valid(state.winid) then return end
  local row = api.nvim_win_get_cursor(state.winid)[1]
  local plines = {}
  for lnum in pairs(state.line_to_plugin) do
    plines[#plines + 1] = lnum
  end
  table.sort(plines)

  local target
  if direction > 0 then
    for i = 1, #plines do
      if plines[i] > row then
        target = plines[i]
        break
      end
    end
    target = target or plines[1]
  else
    for i = #plines, 1, -1 do
      if plines[i] < row then
        target = plines[i]
        break
      end
    end
    target = target or plines[#plines]
  end
  if target then api.nvim_win_set_cursor(state.winid, { target, 0 }) end
end

local function setup_keymaps()
  local opts = { buffer = state.bufnr, silent = true, nowait = true }

  local function map(action, rhs)
    local keys = config.keymaps[action]
    if not keys then return end
    if type(keys) == "string" then
      keys = { keys }
    end
    for _, key in ipairs(keys) do
      vim.keymap.set("n", key, rhs, opts)
    end
  end

  map("close", PackUI.close)

  map("update_all", function ()
    PackUI.close()
    vim.pack.update()
  end)

  map("update_plugin", function ()
    local name = plugin_at_cursor()
    if name then
      PackUI.close()
      vim.pack.update({ name })
    end
  end)

  map("check_updates", PackUI.check_updates)

  map("show_help", function ()
    state.show_help = not state.show_help
    render()
  end)

  map(
    "next_plugin",
    function ()
      jump_plugin(1)
    end
  )
  map(
    "prev_plugin",
    function ()
      jump_plugin(-1)
    end
  )

  map("open_log", function ()
    PackUI.close()
    local log_path = vim.fs.joinpath(vim.fn.stdpath("log"), "nvim-pack.log")
    if vim.uv.fs_stat(log_path) then
      vim.cmd.edit(log_path)
    else
      vim.notify("vim.pack: no log file yet", vim.log.levels.INFO)
    end
  end)

  map("clean_plugins", function ()
    local to_clean = {}
    local plugins = vim.pack.get(nil, { info = false })
    for i = 1, #plugins do
      if not plugins[i].active then to_clean[#to_clean + 1] = plugins[i].spec.name end
    end

    if #to_clean == 0 then
      return vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
    end

    if vim.fn.confirm(
      string.format(
        "Remove %d non-active plugin(s)?\n\n%s", #to_clean, table.concat(to_clean, "\n")
      ), "&Yes\n&No", 2
    )
      == 1 then
      PackUI.close()
      local ok, err = pcall(vim.pack.del, to_clean)
      if ok then
        vim.notify(string.format("vim.pack: removed %d plugin(s)", #to_clean), vim.log.levels.INFO)
      else
        vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end)

  map("delete_plugin", function ()
    local name = plugin_at_cursor()
    if not name then return end

    local ok, pdata = pcall(vim.pack.get, { name }, { info = false })
    if not ok then
      return vim.notify(string.format("vim.pack: %s is not installed", name), vim.log.levels.WARN)
    end
    if #pdata > 0 and pdata[1].active then
      return vim.notify(
        string.format("vim.pack: %s is active, remove from config first", name), vim.log.levels.WARN
      )
    end

    if vim.fn.confirm(string.format("Delete plugin %s?", name), "&Yes\n&No", 2) == 1 then
      PackUI.close()
      local del_ok, err = pcall(vim.pack.del, { name })
      if del_ok then
        vim.notify(string.format("vim.pack: removed %s", name), vim.log.levels.INFO)
      else
        vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end)

  map("toggle_details", function ()
    local name = plugin_at_cursor()
    if name then
      local commits = state.updates[name]
      local has_truncated = commits and #commits > config.max_commits_preview
      if not state.expanded[name] then
        state.expanded[name] = true
      elseif has_truncated and not state.show_all_commits[name] then
        state.show_all_commits[name] = true
      else
        state.expanded[name], state.show_all_commits[name] = false, nil
      end

      render()
      if state.plugin_lines[name] then
        api.nvim_win_set_cursor(state.winid, { state.plugin_lines[name], 0 })
      end
    end
  end)
end

function PackUI.open()
  if state.winid and api.nvim_win_is_valid(state.winid) then
    return api.nvim_set_current_win(state.winid)
  end
  setup_highlights()

  state.bufnr = api.nvim_create_buf(false, true)
  vim.bo[state.bufnr].buftype, vim.bo[state.bufnr].bufhidden = "nofile", "wipe"
  vim.bo[state.bufnr].swapfile, vim.bo[state.bufnr].filetype = false, "pack-ui"

  local cols, lines = vim.o.columns, vim.o.lines
  local width = math.min(cols - 4, math.max(math.floor(cols * 0.8), 60))
  local height = math.min(lines - 4, math.max(math.floor(lines * 0.7), 20))

  state.winid = api.nvim_open_win(state.bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((lines - height) / 2),
    col = math.floor((cols - width) / 2),
    style = "minimal",
    border = config.border,
    title = " vim.pack ",
    title_pos = "center",
  })
  vim.wo[state.winid].cursorline, vim.wo[state.winid].wrap = true, false

  render()
  setup_keymaps()

  local captured_winid = state.winid
  state.win_autocmd_id = api.nvim_create_autocmd("WinClosed", {
    buffer = state.bufnr,
    once = true,
    callback = function (ev)
      if vim._tointeger(ev.match) == captured_winid then
        state.win_autocmd_id = nil
        reset_state()
      end
    end,
  })
end

-- ============================================================================
-- Public Module Setup
-- ============================================================================

--- Initialises the UI module and registers commands
---@param opts? PackUiConfig
function PackUI.setup(opts)
  opts = opts or {}

  if opts.max_commits_preview then config.max_commits_preview = opts.max_commits_preview end
  if opts.border then config.border = opts.border end

  -- Safely override keymaps without array merging conflicts
  if opts.keymaps then
    for k, v in pairs(opts.keymaps) do
      config.keymaps[k] = v
    end
  end

  vim.api.nvim_create_user_command(
    "Pack",
    function (cmd_opts)
      PackUI.open()
      if cmd_opts.args == "check" then
        PackUI.check_updates()
      elseif cmd_opts.args == "update" or cmd_opts.args == "update-all" then
        PackUI.close()
        vim.pack.update()
      end
    end,
    {
      nargs = "?",
      complete = function () return { "check", "update", "update-all" } end,
      desc = "Open vim.pack plugin manager UI",
    }
  )
end

return PackUI
