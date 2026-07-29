---@class WindowState
---@field is_disabled  boolean
---@field pills        table<string, string> Formatted "%#hl#content" string per component
---@field final_string string                Pre-compiled statusline string

---@class RenderState
---@field components table<string, ComponentDef>
---@field events     table<string, string>
---@field registry   table<string, string>

local api = vim.api
local cache = require("ui.statusline.cache")
local hl_mod = require("ui.statusline.highlight")
local comp_mod = require("ui.statusline.components")
local config = _G["Statusline"].config

local Render = {}

---@type RenderState
local state = { components = {}, events = {}, registry = {} }

local _sep_left = ""
local _sep_right = ""
local _has_left = false
local _has_right = false

--- Registers a component for rendering
---@param id         string
---@param registered table<string, boolean>
local function register_component(id, registered)
  if registered[id] or not state.components[id] then return end
  registered[id] = true
  table.insert(state.registry, id)
  for i = 1, #(state.components[id].events or {}) do
    local event = state.components[id].events[i]
    state.events[event] = state.events[event] or {}
    table.insert(state.events[event], id)
  end
end

--- Builds a formatted "%#hl#content" pill string from a raw value.
--- Returns "" for empty values so callers can cheaply skip invisible pills.
---@param comp_id string
---@param value   string
---@param winid   integer
---@return string
local function build_pill(comp_id, value, winid)
  if value == "" then return "" end

  local comp = state.components[comp_id]
  local comp_hl = comp.resolve_hl and comp.resolve_hl(winid) or comp.hl
  local max_w = comp.max_width
  local content = (max_w and max_w > 0) and string.format("%%.%d(%s%%)", max_w, value) or value

  local hl_tag = "%#" .. comp_hl .. "#"

  if not _has_left and not _has_right then
    return hl_tag .. content
  end

  local sep_tag = "%#" .. hl_mod.get_separator_hl(comp_hl) .. "#"
  local left = _has_left and (sep_tag .. _sep_left) or ""
  local right = _has_right and (sep_tag .. _sep_right) or ""
  return left .. hl_tag .. content .. right
end

--- Assembles visible pills for a section into a space-separated string.
---@param ids string[]
---@param ws  WindowState
---@return string
local function build_section(ids, ws)
  local parts = {}

  for i = 1, #ids do
    local pill = ws.pills[ids[i]]
    if pill and pill ~= "" then
      parts[#parts + 1] = pill
    end
  end

  return table.concat(parts, " ")
end

--- Re-renders one component. Returns true if its pill string changed.
---@param comp_id string
---@param ws      WindowState
---@param winid   integer
---@param args    table
---@return boolean
local function update_component(comp_id, ws, winid, args)
  local comp = state.components[comp_id]
  local new_val = ""

  if not comp.condition or comp.condition(winid) then
    new_val = comp.render(args, winid) or ""
  end

  local new_pill = build_pill(comp_id, new_val, winid)
  if ws.pills[comp_id] ~= new_pill then
    ws.pills[comp_id] = new_pill
    return true
  end
  return false
end

--- Updates all target components for one window. Returns true if any pill changed.
---@param winid        integer
---@param ws           WindowState
---@param target_comps string | table<string, string>
---@param args         table
---@return boolean
local function update_window(winid, ws, target_comps, args)
  local was_disabled = ws.is_disabled
  ws.is_disabled = (vim.b[args.buf or 0].statusline_disable == true)
    or (vim.bo[args.buf or 0].filetype == "ministarter")

  if ws.is_disabled then
    if ws.final_string ~= " " then
      ws.final_string = " "
      return true
    end
    return false
  end

  local dirty = was_disabled
  for i = 1, #target_comps do
    if update_component(target_comps[i], ws, winid, args) then
      dirty = true
    end
  end

  if dirty then
    local left = build_section(config.components.left, ws)
    local right = build_section(config.components.right, ws)

    if left == "" and right == "" then
      ws.final_string = " "
    elseif left ~= "" and right ~= "" then
      ws.final_string = left .. " %<%=" .. right -- truncate right section first
    else
      ws.final_string = (left ~= "" and left or right) .. "%*"
    end
  end

  return dirty
end

--- Called on every statusline redraw via `%!v:lua._StatuslineNew_Eval()`.
---@return string
function Render.evaluate()
  if vim.g.statusline_disable == true then return " " end
  local winid = vim.g.statusline_winid or api.nvim_get_current_win()
  local ws = cache.win[winid]
  return ws.final_string
end

---@return table<string, string>
function Render.init()
  setmetatable(cache.win, {
    __index = function (self, winid)
      local ws = { is_disabled = false, pills = {}, final_string = " " }
      rawset(self, winid, ws)
      update_window(winid, ws, state.registry, {
        event = "Init",
        buf = api.nvim_win_get_buf(winid),
      })
      return ws
    end,
  })

  state.components = comp_mod.components
  _sep_left = config.separators.left or ""
  _sep_right = config.separators.right or ""
  _has_left = _sep_left ~= ""
  _has_right = _sep_right ~= ""

  local seen = {}
  for _, id in ipairs(config.components.left or {}) do
    register_component(id, seen)
  end
  for _, id in ipairs(config.components.right or {}) do
    register_component(id, seen)
  end
  return state.events
end

--- Dispatched by every registered autocmd. Re-evaluates subscribed components
--- across all live windows, diffing pills to avoid unnecessary redraws.
---@param args table
function Render.on_event(args)
  local event_name = args.event == "User" and ("User " .. (args.match or "")) or args.event
  local target_comps = state.events[event_name]
  if not target_comps then return end

  local did_change = false
  local event_buf = args.buf

  for winid, ws in pairs(cache.win) do
    if not api.nvim_win_is_valid(winid) then
      cache.win[winid] = nil
    else
      local bufnr = api.nvim_win_get_buf(winid)
      if not event_buf or event_buf == bufnr then
        if update_window(winid, ws, target_comps, args) then
          did_change = true
        end
      end
    end
  end

  if did_change then vim.cmd("redrawstatus") end
end

return Render
