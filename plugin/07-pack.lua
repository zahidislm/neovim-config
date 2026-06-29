-- ============================================================================
-- Neovim 0.12+ vim.pack API Wrapper
-- ============================================================================

---@class PackKeymap
---@field [1]     string            LHS trigger
---@field [2]     string | function RHS action
---@field mode?   string | string[] Mode(s) (default: "n")
---@field desc?   string            Description
---@field expr?   boolean           Expression mapping
---@field silent? boolean           Silent mapping (default: true)

---@class PackData
---@field dependencies? (string | table)[]         List of plugin specs to load prior
---@field init?         string | function          Vim command/function run before load
---@field config?       boolean | table | function Setup table/function run after load
---@field main?         string                     Explicit module to require
---@field build?        string | function          Shell/Vim command (starts with :) or function
---@field keys?         PackKeymap[]               Keybindings to set on load
---@field sync?         boolean                    Load immediately during Neovim's startup phase
---@field _queued?      boolean                    DFS deduplication state
---@field _loaded?      boolean                    Execution deduplication state

local ALT_HOSTS = { gl = "https://gitlab.com/", cb = "https://codeberg.org/" }

---@type table<string, PackData>
local registry = {}
local queue = {}
local sync_queue = {}
local scheduled = false

-- ============================================================================
-- Utilities
-- ============================================================================

local function try(msg, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then
    vim.notify(string.format("%s: %s", msg, err), vim.log.levels.WARN)
  end
end

local function infer_main(name)
  return name
    :gsub("%.git$", "")
    :gsub("%.nvim$", "")
    :gsub("%.lua$", "")
    :gsub("^nvim%-", "")
    :gsub("^lua%-", "")
end

-- ============================================================================
-- Core Execution
-- ============================================================================

local function setup_plugin(name)
  local data = registry[name]
  if not data or data._loaded then return end

  if type(data.init) == "function" then
    try("Init failed [" .. name .. "]", data.init)
  elseif type(data.init) == "string" then
    try("Init failed [" .. name .. "]", vim.cmd, data.init)
  end

  if data.config then
    if type(data.config) == "function" then
      try("Config failed [" .. name .. "]", data.config)
    else
      local mod = data.main or infer_main(name)
      local ok, m = pcall(require, mod)

      if ok and type(m.setup) == "function" then
        try(
          "Setup failed [" .. name .. "]", m.setup,
          type(data.config) == "table" and data.config or nil
        )
      elseif not ok then
        vim.notify(
          string.format("Module '%s' not found for '%s'. Try specifying `data.main`.", mod, name),
          vim.log.levels.WARN
        )
      end
    end
  end

  for _, k in ipairs(data.keys or {}) do
    vim.keymap.set(k.mode or "n", k[1], k[2], {
      desc = k.desc,
      expr = k.expr,
      silent = k.silent ~= false,
    })
  end

  data._loaded = true
end

-- ============================================================================
-- Resolution Engine
-- ============================================================================

--- Resolve a raw spec into a native vim.pack entry and route it to the
--- correct queue.
---@param raw           string | table Raw spec as passed to Pack.add
---@param inherit_sync? boolean        True when a sync parent is pulling this in as a dependency
local function queue_spec(raw, inherit_sync)
  local spec = type(raw) == "string" and { src = raw } or raw
  local src = spec.src or spec[1]

  if not src then return end

  local clean_path = src:gsub("[/\\]+$", "")
  local name = spec.name or clean_path:match("([^/\\]+)%.git$") or clean_path:match("([^/\\]+)$")

  local data = registry[name] or { _loaded = false, _queued = false }

  if type(spec.data) == "table" then
    for k, v in pairs(spec.data) do
      data[k] = v
    end
  end

  registry[name] = data

  -- A plugin is sync if it declares sync = true, or if a sync-marked
  -- parent is pulling it in as a dependency.  Dependencies always inherit
  -- the sync status of their dependant so a sync plugin is never left
  -- waiting for a deferred dep.
  local is_sync = inherit_sync or data.sync or false

  if data._queued then return end
  data._queued = true

  for _, dep in ipairs(data.dependencies or {}) do
    queue_spec(dep, is_sync)
  end

  -- Build native vim.pack.Spec
  local native = { name = name, version = spec.version }
  local host, rest = src:match("^([a-z]+):(.+)$")
  native.src = (host and ALT_HOSTS[host]) and (ALT_HOSTS[host] .. rest)
    or (src:find("://") and src or "https://github.com/" .. src)

  table.insert(is_sync and sync_queue or queue, native)
end

-- ============================================================================
-- Global API & Hooks
-- ============================================================================

--- Pass a batch of native specs to vim.pack.add with a shared load callback.
---@param batch table[]
local function flush_batch(batch)
  vim.pack.add(batch, {
    confirm = false,
    load = function (p)
      try("Mount failed [" .. p.spec.name .. "]", vim.cmd, "packadd " .. p.spec.name)
      setup_plugin(p.spec.name)
    end,
  })
end

local function flush()
  if #queue > 0 then
    flush_batch(queue)
    queue = {}
  end
  scheduled = false
end

_G.Pack = {
  ---Register one or more plugin specs.
  ---@param specs string | table | table[]
  add = function (specs)
    local is_single = type(specs) == "string"
      or (type(specs) == "table" and (type(specs[1]) == "string" or specs.src))

    if is_single then
      queue_spec(specs)
    else
      for _, s in ipairs(specs) do
        queue_spec(s)
      end
    end

    if #sync_queue > 0 then
      flush_batch(sync_queue)
      sync_queue = {}
    end

    if not scheduled and #queue > 0 then
      scheduled = true
      vim.schedule(flush)
    end
  end,
}

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("PluginHooks", { clear = true }),
  callback = function (ev)
    local spec = ev.data.spec
    if not spec or ev.data.kind == "delete" then return end

    local plugin = registry[spec.name]
    if not (plugin and plugin.build) then return end

    vim.schedule(function ()
      local b = plugin.build
      if type(b) == "function" then
        try("Build failed [" .. spec.name .. "]", b, ev.data.path)
      elseif type(b) == "string" then
        if b:sub(1, 1) == ":" then
          local ok, err = pcall(vim.cmd, b)
          local lvl = ok and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify(
            string.format(
              "Build %s [%s]%s", ok and "succeeded" or "failed", spec.name, ok and "" or ": " .. err
            ), lvl
          )
        else
          vim.system({ "sh", "-c", b }, { cwd = ev.data.path, text = true }, function (res)
            vim.schedule(function ()
              local ok = res.code == 0
              local lvl = ok and vim.log.levels.INFO or vim.log.levels.WARN
              vim.notify(
                string.format(
                  "Build %s [%s]%s", ok and "succeeded" or "failed", spec.name,
                  ok and "" or ": " .. vim.trim(res.stderr or res.stdout)
                ), lvl
              )
            end)
          end)
        end
      end
    end)
  end,
})
