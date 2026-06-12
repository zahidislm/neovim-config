local api = vim.api
local ts = vim.treesitter

---@alias FoldChunk { [1]: string, [2]: string }

---@class FoldCacheEntry
---@field text   string
---@field chunks FoldChunk[]

--- Cache for parsed fold lines.
---@type table<integer, table<integer, FoldCacheEntry>>
local cache = {}

-- Prevent memory leaks by explicitly clearing the cache when a buffer is wiped.
api.nvim_create_autocmd("BufWipeout", {
  group = api.nvim_create_augroup("FoldTextCacheCleanup", { clear = true }),
  callback = function (args)
    cache[args.buf] = nil
  end,
})

local ICON_LEFT = ""
local ICON_RIGHT = ""
local HL_TEXT = "FoldedText"
local HL_SEP = "FoldedSep"
local HL_BASE = "Folded"

-- Fetch icons dynamically in case they are updated at runtime
local function get_icons()
  local iconchars = vim.g.iconchars
  if iconchars and type(iconchars) == "table" and iconchars.statusline then
    local seps = iconchars.statusline.separators or {}
    return seps.left or ICON_LEFT, seps.right or ICON_RIGHT
  end
  return ICON_LEFT, ICON_RIGHT
end

---@class TsHighlightEvent
---@field col  integer
---@field type integer 1 for start, -1 for end
---@field p    integer Priority
---@field name string  Highlight group name

--- Parses a specific line in a buffer and returns Tree-sitter highlighted chunks.
---@param bufnr   integer
---@param linenum integer
---@return FoldChunk[]
local function parse_line(bufnr, linenum)
  local line = api.nvim_buf_get_lines(bufnr, linenum - 1, linenum, false)[1]
  if not line or line == "" then
    return { { line or "", HL_BASE } }
  end

  cache[bufnr] = cache[bufnr] or {}
  local buf_cache = cache[bufnr]

  if buf_cache[linenum] and buf_cache[linenum].text == line then
    return buf_cache[linenum].chunks
  end

  local parser = ts.get_parser(bufnr, nil, { error = false })
  local tree = parser and parser:trees()[1]
  local query = tree and ts.query.get(parser:lang(), "highlights")

  if not query then
    return { { line, HL_BASE } }
  end

  local events = {} ---@type TsHighlightEvent[]
  local line_len = #line
  local row = linenum - 1

  for id, node, metadata in query:iter_captures(tree:root(), bufnr, row, linenum) do
    local s_row, s_col, e_row, e_col = node:range()

    if s_row <= row and e_row >= row then
      local s = (s_row < row) and 0 or s_col
      local e = (e_row > row) and line_len or e_col
      local p = (metadata and tonumber(metadata.priority)) or 100
      local name = "@" .. query.captures[id]

      table.insert(events, { col = s, type = 1, p = p, name = name })
      table.insert(events, { col = e, type = -1, p = p, name = name })
    end
  end

  -- Sweep-line interval sorting
  table.sort(events, function (a, b)
    if a.col == b.col then
      return a.type < b.type
    end
    return a.col < b.col
  end)

  local result = {} ---@type FoldChunk[]
  local active = {} ---@type table<string, integer>
  local cursor = 0

  for _, event in ipairs(events) do
    if event.col > cursor then
      local best_p, best_hl = -1, HL_BASE
      for name, p in pairs(active) do
        if p >= best_p then
          best_p, best_hl = p, name
        end
      end

      local chunk_text = line:sub(cursor + 1, event.col)
      table.insert(result, { chunk_text, best_hl })
      cursor = event.col
    end

    if event.type == 1 then
      active[event.name] = event.p
    else
      active[event.name] = nil
    end
  end

  if cursor < line_len then
    table.insert(result, { line:sub(cursor + 1), HL_BASE })
  end

  if #result == 0 then
    result = { { line, HL_BASE } }
  end

  buf_cache[linenum] = { text = line, chunks = result }
  return result
end

local M = {}

--- Main renderer called by Neovim's foldtext option.
---@return FoldChunk[]
function M.render()
  local bufnr = api.nvim_get_current_buf()
  local start_row = vim.v.foldstart
  local end_row = vim.v.foldend

  local start_chunks = parse_line(bufnr, start_row)
  local result = {} ---@type FoldChunk[]

  for _, c in ipairs(start_chunks) do
    table.insert(result, { c[1], c[2] })
  end

  -- Trim trailing whitespace from the final chunk of the start line
  local last = result[#result]
  if last then
    last[1] = last[1]:gsub("%s+$", "")
    if last[1] == "" then
      table.remove(result)
    end
  end

  local left_icon, right_icon = get_icons()
  local folded_lines = end_row - start_row

  local info = {
    { " " .. left_icon, HL_SEP }, { "+" .. folded_lines .. " lines", HL_TEXT },
    { right_icon .. " ", HL_SEP },
  }

  for _, item in ipairs(info) do
    table.insert(result, item)
  end

  local end_chunks = parse_line(bufnr, end_row)
  local first_end = true

  for _, chunk in ipairs(end_chunks) do
    local text = chunk[1]
    if first_end then
      -- Trim leading whitespace from the first chunk of the end line
      text = text:gsub("^%s+", "")
      first_end = false
    end

    if text ~= "" then
      table.insert(result, { text, chunk[2] })
    end
  end

  return result
end

return M
