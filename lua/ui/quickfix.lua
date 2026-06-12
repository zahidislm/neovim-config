--- Custom quickfix menu for Neovim.
--- Provides a formatted `quickfixtextfunc`
---
--- Dependencies (all optional):
---   - mini.icons : file-type icons via MiniIcons.get()
---
--- nvim-bqf users: set the fzf delimiter to match the │ separator used here:
---   require('bqf').setup({
---     filter = { fzf = { extra_opts = { '--delimiter', '│' } } }
---   })

---@class QuickfixModule
local M = {}

-- ---------------------------------------------------------------------------
-- Constants
-- ---------------------------------------------------------------------------

-- Highlight Namespace
local hl_ns = vim.api.nvim_create_namespace("QfIconHighlights")

--- Path segments matching any of these patterns are kept verbatim (not shortened).
---@type string[]
local RAW_SEGMENT_PATTERNS = { "nvim$" }

--- Column separator. Must match the `--delimiter` in nvim-bqf's fzf extra_opts.
local SEPARATOR = "│"

local sev = vim.diagnostic.severity
local TYPE_MAP = {
  e = { sev.ERROR, "DiagnosticSignError" },
  E = { sev.ERROR, "DiagnosticSignError" },
  w = { sev.WARN, "DiagnosticSignWarn" },
  W = { sev.WARN, "DiagnosticSignWarn" },
  i = { sev.INFO, "DiagnosticSignInfo" },
  I = { sev.INFO, "DiagnosticSignInfo" },
  n = { sev.HINT, "DiagnosticSignHint" },
  N = { sev.HINT, "DiagnosticSignHint" },
}

-- ---------------------------------------------------------------------------
-- Cache
-- ---------------------------------------------------------------------------
local path_cache = {}
local width_cache = {}

--- Get cell-width of string
---@param str string
---@return integer
local function get_width(str)
  if not width_cache[str] then
    width_cache[str] = vim.fn.strdisplaywidth(str)
  end
  return width_cache[str]
end

-- ---------------------------------------------------------------------------
-- Diagnostic sign helpers
-- ---------------------------------------------------------------------------

--- Reads sign text configured via vim.diagnostic.config().
--- Returns a table keyed by vim.diagnostic.severity integers.
--- Falls back to plain ASCII letters when the user has not set icon text.
---@return table<integer, string>
local function get_signs()
  local cfg = vim.diagnostic.config() or {}
  local text = vim.tbl_get(cfg, "signs", "text") or {}
  return {
    [sev.ERROR] = text[sev.ERROR] or "E",
    [sev.WARN] = text[sev.WARN] or "W",
    [sev.INFO] = text[sev.INFO] or "I",
    [sev.HINT] = text[sev.HINT] or "N",
  }
end

--- Returns the display icon for a single item's type.
---@param type_char  string Raw item.type string
---@param signs      table<integer, string>
---@param is_loclist boolean
---@return string, string
local function get_diag_icon(type_char, signs, is_loclist)
  local map = TYPE_MAP[type_char or ""]
  if map then
    return signs[map[1]] .. " ", map[2]
  end
  return (is_loclist and " " or "󱈤 "), ""
end

-- ---------------------------------------------------------------------------
-- Path helpers
-- ---------------------------------------------------------------------------

--- Shortens interior path segments to 1–2 characters.
--- Hidden segments (starting with ".") keep 2 chars; others keep 1.
--- The first, last, and any "raw" segments are preserved in full.
---@param path string
---@return string
local function shorten_path(path)
  if path_cache[path] then return path_cache[path] end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep, { trimempty = true })
  local out = {}

  for i, part in ipairs(parts) do
    local is_raw = false
    for _, p in ipairs(RAW_SEGMENT_PATTERNS) do
      if part:match(p) then
        is_raw = true
        break
      end
    end

    if i == 1 or i == #parts or is_raw then
      table.insert(out, part)
    else
      local len = part:match("^%.") and 2 or 1
      table.insert(out, vim.fn.strcharpart(part, 0, len))
    end
  end

  path_cache[path] = table.concat(out, sep)
  return path_cache[path]
end

--- Pads `text` with spaces so its display width equals `width`.
---@param text  string
---@param width integer
---@return string
local function center(text, width)
  local diff = width - get_width(text)
  if diff <= 0 then return text end
  return string.rep(" ", math.floor(diff / 2)) .. text .. string.rep(" ", math.ceil(diff / 2))
end

-- ---------------------------------------------------------------------------
-- Icon helper
-- ---------------------------------------------------------------------------

--- Returns a file-type icon for `full_path` using mini.icons.
--- Returns an empty string when mini.icons is not loaded or the path is empty + highlight
---@return string, string
local function get_file_icon(path)
  if not _G.MiniIcons or path == "" then return "", "" end
  local icon, hl = _G.MiniIcons.get("file", path)
  return icon .. " ", hl
end

-- ---------------------------------------------------------------------------
-- Item processing
-- ---------------------------------------------------------------------------

---@class QfItemInfo
---@field valid    boolean True when the item has file/position data.
---@field prefix   string  Diagnostic/Filetype icon + filename
---@field prefix_w integer Width of prefix
---@field row      string  Row range string (e.g. "10" or "10-12").
---@field pos_w    integer Width of row string
---@field text     string  Display text for the entry.

--- Converts a raw quickfix/loclist item into a display-ready record.
---
--- Invalid items (item.valid ~= 1) skip all file/position resolution and
---
--- For quickfix lists (`use_buffer_text = true`) the live buffer line at
--- item.lnum is preferred over item.text when the buffer is loaded.
--- For location lists (`use_buffer_text = false`) item.text is always used.
---
---@param item       table
---@param use_buffer boolean
---@param signs      table<integer, string>
---@param is_loclist boolean
---@param line_idx   integer
---@param hl_queue   table
---@return QfItemInfo | table
local function item_to_info(item, signs, use_buffer, is_loclist, line_idx, hl_queue)
  if item.valid ~= 1 then
    return { valid = false, text = item.text }
  end

  local full_path = vim.api.nvim_buf_get_name(item.bufnr)
  local name = shorten_path(vim.fn.fnamemodify(full_path, ":~:."))
  local row = item.lnum ~= item.end_lnum and (item.lnum .. "-" .. item.end_lnum)
    or tostring(item.lnum)
  local text = item.text

  if use_buffer and vim.api.nvim_buf_is_loaded(item.bufnr) then
    text = vim.api.nvim_buf_get_lines(item.bufnr, item.lnum - 1, item.lnum, false)[1] or item.text
  end

  local d_icon, d_hl = get_diag_icon(item.type, signs, is_loclist)
  local f_icon, f_hl = get_file_icon(full_path)

  if hl_queue then
    local d_len, f_len = #d_icon, #f_icon
    if d_hl ~= "" then table.insert(hl_queue, { line_idx, 0, d_len, d_hl }) end
    if f_hl ~= "" then table.insert(hl_queue, { line_idx, d_len, d_len + f_len, f_hl }) end
  end

  local prefix = d_icon .. f_icon .. name

  return {
    valid = true,
    prefix = prefix,
    prefix_w = get_width(prefix),
    row = row,
    pos_w = get_width(row),
    text = text,
  }
end

--- Formats a list of item info records into aligned display strings.
---
--- Layout for valid items:
---   <diag_icon><file_icon><right-padded path> │ <centered position> │ <text>
---
--- Invalid items render as bare text with no column structure.
---@param infos QfItemInfo[]
---@return string[]
local function format_lines(infos)
  local path_col_w, pos_col_w = 0, 0

  for _, info in ipairs(infos) do
    if info.valid then
      path_col_w = math.max(path_col_w, info.prefix_w)
      pos_col_w = math.max(pos_col_w, info.pos_w)
    end
  end

  local lines = {}
  for i, info in ipairs(infos) do
    if not info.valid then
      lines[i] = info.text
    else
      local padding = string.rep(" ", path_col_w - info.prefix_w)
      local pos = center(info.row, pos_col_w)
      lines[i] = info.prefix .. padding
        .. " " .. SEPARATOR
        .. " " .. pos
        .. " " .. SEPARATOR
        .. " " .. info.text
    end
  end

  return lines
end

--- Applies highlights to filetype/diagnostic icon
---@param qfbufnr   integer
---@param hl_queue  table
---@param start_idx integer
---@param end_idx   integer
local function apply_highlights(qfbufnr, hl_queue, start_idx, end_idx)
  if qfbufnr == 0 or #hl_queue == 0 then return end

  vim.schedule(function ()
    if not vim.api.nvim_buf_is_valid(qfbufnr) then return end
    vim.api.nvim_buf_clear_namespace(qfbufnr, hl_ns, start_idx - 1, end_idx)

    for _, hl in ipairs(hl_queue) do
      vim.api.nvim_buf_set_extmark(qfbufnr, hl_ns, hl[1], hl[2], {
        end_col = hl[3],
        hl_group = hl[4],
        priority = 100,
        strict = false,
      })
    end
  end)
end

--- Collects and formats a slice of a raw item list.
---@param items           table[]
---@param start_idx       integer
---@param end_idx         integer
---@param use_buffer_text boolean
---@param is_loclist      boolean
---@return string[]
local function process_items(items, start_idx, end_idx, use_buffer_text, is_loclist, qfbufnr)
  local signs = get_signs()
  local infos = {}
  local hl_queue = {}

  -- Pass `hl_queue` to `item_to_info` only if the quickfix buffer exists to collect highlights
  local queue_ref = qfbufnr ~= 0 and hl_queue or nil

  for i = start_idx, end_idx do
    local info = item_to_info(items[i], signs, use_buffer_text, is_loclist, i - 1, queue_ref)
    table.insert(infos, info)
  end

  apply_highlights(qfbufnr, hl_queue, start_idx, end_idx)

  return format_lines(infos)
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

--- Generates display lines for a location list window.
--- Always uses item.text (the diagnostic message); never the raw buffer line.
---@param data table
---@return string[]
function M.loc_text(data)
  local qf_info = vim.fn.getloclist(data.winid, { id = data.id, items = 0, qfbufnr = 0 })
  return process_items(qf_info.items, data.start_idx, data.end_idx, false, true, qf_info.qfbufnr)
end

--- Generates display lines for a quickfix list window.
--- Uses the live buffer line when the buffer is loaded (shows source context).
---@param data table
---@return string[]
function M.qf_text(data)
  local qf_info = vim.fn.getqflist({ id = data.id, items = 0, qfbufnr = 0 })
  return process_items(qf_info.items, data.start_idx, data.end_idx, true, false, qf_info.qfbufnr)
end

--- Entry point for `quickfixtextfunc`. Dispatches to qf_text or loc_text.
---@param data table
---@return string[]
function M.text(data)
  return data.quickfix == 1 and M.qf_text(data) or M.loc_text(data)
end

return M
