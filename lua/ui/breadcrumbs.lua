local M = {}

-- LSP SymbolKind (integer) → mini.icons "lsp" category name
---@type table<integer, string>
local lsp_kind_names = {
  [1] = "file",
  [2] = "module",
  [3] = "namespace",
  [4] = "package",
  [5] = "class",
  [6] = "method",
  [7] = "property",
  [8] = "field",
  [9] = "constructor",
  [10] = "enum",
  [11] = "interface",
  [12] = "function",
  [13] = "variable",
  [14] = "constant",
  [15] = "string",
  [16] = "number",
  [17] = "boolean",
  [18] = "array",
  [19] = "object",
  [20] = "key",
  [21] = "null",
  [22] = "enummember",
  [23] = "struct",
  [24] = "event",
  [25] = "operator",
  [26] = "typeparameter",
}

-- Tree-sitter node type → mini.icons "lsp" kind name (reuses lsp icon infrastructure).
-- Covers the mainstream grammars bundled with nvim-treesitter; extend as needed.
---@type table<string, string>
local ts_scope_kinds = {
  -- Functions
  function_declaration = "function",           -- JS/TS, Go, Lua, C#
  function_definition = "function",            -- Python, C/C++
  function_item = "function",                  -- Rust
  local_function = "function",                 -- Lua  (`local function foo()`)
  generator_function_declaration = "function", -- JS
  -- Anonymous forms: name resolved from enclosing assignment
  function_expression = "function",            -- JS/TS
  arrow_function = "function",                 -- JS/TS
  -- Methods
  method_declaration = "method",               -- Java, Go, C#
  method_definition = "method",                -- JS/TS
  method = "method",                           -- Ruby
  -- Classes
  class_declaration = "class",                 -- JS/TS, Java, C#
  class_definition = "class",                  -- Python
  class_specifier = "class",                   -- C++
  class = "class",                             -- Ruby
  -- Structs
  struct_item = "struct",                      -- Rust
  struct_specifier = "struct",                 -- C/C++
  -- Enumerations
  enum_item = "enum",                          -- Rust
  enum_declaration = "enum",                   -- Java, TS
  enum_specifier = "enum",                     -- C/C++
  -- Interfaces / Traits
  trait_item = "interface",                    -- Rust
  interface_declaration = "interface",         -- Java, TS
  -- Namespaces / Modules
  namespace_definition = "namespace",          -- C++
  mod_item = "module",                         -- Rust
  -- Impl blocks (Rust): shown as "impl <Type>" for context
  impl_item = "struct",
}

---@type table<string, string>
local icon_cache = {}

---@param category string
---@param name     string
---@return string Winbar highlight-wrapped icon, or "" when MiniIcons is unavailable.
local function get_icon(category, name)
  if not _G.MiniIcons then
    return ""
  end
  local key = category .. ":" .. name
  if not icon_cache[key] then
    local icon, i_hl_name = _G.MiniIcons.get(category, name)
    local i_hl = vim.api.nvim_get_hl(0, { name = i_hl_name })
    local bg_hl = vim.api.nvim_get_hl(0, { name = "StatusLineRuler" })
    vim.api.nvim_set_hl(0, "Breadcrumb_" .. i_hl_name, {
      fg = i_hl.fg,
      bg = bg_hl.bg,
    })

    icon_cache[key] = "%#" .. "Breadcrumb_" .. i_hl_name .. "#" .. icon .. "%#StatusLineRuler#"
  end
  return icon_cache[key]
end

-- ---------------------------------------------------------------------------
-- LSP helpers
-- ---------------------------------------------------------------------------

---@param range table   LSP Range
---@param line  integer 0-indexed
---@param char  integer 0-indexed
---@return boolean
local function range_contains_pos(range, line, char)
  local start = range.start
  local stop = range["end"]
  if line < start.line or line > stop.line then return false end
  if line == start.line and char < start.character then return false end
  if line == stop.line and char > stop.character then return false end
  return true
end

---@param symbol_list table[]?
---@param line        integer  0-indexed
---@param char        integer  0-indexed
---@param path        string[] Mutated in place
---@return boolean
local function find_symbol_path(symbol_list, line, char, path)
  if not symbol_list or #symbol_list == 0 then
    return false
  end
  for _, symbol in ipairs(symbol_list) do
    if range_contains_pos(symbol.range, line, char) then
      local kind_name = lsp_kind_names[symbol.kind]
      local icon = kind_name and get_icon("lsp", kind_name) or ""
      table.insert(path, (icon ~= "" and icon .. " " or "") .. symbol.name)
      find_symbol_path(symbol.children, line, char, path)
      return true
    end
  end
  return false
end

-- ---------------------------------------------------------------------------
-- Tree-sitter helpers
-- ---------------------------------------------------------------------------

---@param node  TSNode
---@param bufnr integer
---@return string?
local function extract_scope_name(node, bufnr)
  -- Most grammars expose the identifier via a "name" field directly on the
  -- scope node (Python def/class, JS/TS function/class, Rust fn/struct/enum,
  -- Go func/method, Java method/class, Ruby method/class, …).
  local name_nodes = node:field("name")
  if name_nodes[1] then
    return vim.treesitter.get_node_text(name_nodes[1], bufnr)
  end

  local ntype = node:type()

  -- Rust impl blocks have a "type" field rather than "name".
  if ntype == "impl_item" then
    local type_nodes = node:field("type")
    if type_nodes[1] then
      return "impl " .. vim.treesitter.get_node_text(type_nodes[1], bufnr)
    end
    return nil
  end

  -- C/C++: the name is buried under one or more declarator layers.
  -- e.g. function_definition → function_declarator → identifier
  -- or → pointer_declarator → function_declarator → identifier
  -- or → function_declarator → qualified_identifier (name field) → identifier
  if ntype == "function_definition" then
    local d = node:field("declarator")[1]
    while d do
      local dt = d:type()
      if dt == "identifier" or dt == "type_identifier" or dt == "field_identifier" then
        return vim.treesitter.get_node_text(d, bufnr)
      end
      local inner = d:field("name")
      if inner[1] then
        return vim.treesitter.get_node_text(inner[1], bufnr)
      end
      d = d:field("declarator")[1]
    end
    return nil
  end

  -- Anonymous functions / lambdas: try to recover a name from the
  -- immediately enclosing assignment.
  local parent = node:parent()
  if not parent then
    return nil
  end
  local pt = parent:type()

  -- JS/TS:  const foo = function() {}  /  const foo = () => {}
  -- class field:  foo = () => {}  (public_field_definition)
  if pt == "variable_declarator" or pt == "public_field_definition" then
    local pname = parent:field("name")
    if pname[1] then
      return vim.treesitter.get_node_text(pname[1], bufnr)
    end
  end

  -- Lua:  M.foo = function() end  /  foo = function() end
  -- The grammar may wrap the LHS in a variable_list node.
  if pt == "assignment_statement" or pt == "assignment" then
    local first = parent:named_child(0)
    if first and first ~= node then
      local ft = first:type()
      local var_node = (ft == "variable_list" or ft == "name_list") and first:named_child(0)
        or first
      if var_node then
        local text = vim.treesitter.get_node_text(var_node, bufnr)
        -- Extract the last identifier segment from "M.foo" or "M:bar"
        return text:match("[%w_]+$")
      end
    end
  end

  return nil
end

-- ---------------------------------------------------------------------------
-- Shared
-- ---------------------------------------------------------------------------

---@param crumbs string[]
---@param winnr  integer
local function apply_winbar(crumbs, winnr)
  local text = " "
  if #crumbs > 0 then
    text = "%#StatusLineSep_StatusLineRuler#" .. vim.g.iconchars.statusline.separators.left
      .. table.concat(crumbs, " > ") .. "%#StatusLineSep_StatusLineRuler#"
      .. vim.g.iconchars.statusline.separators.right
  end

  vim.api.nvim_set_option_value("winbar", text, { win = winnr })
end

-- ---------------------------------------------------------------------------
-- LSP path
-- ---------------------------------------------------------------------------

---@param err         table?
---@param symbols     table[]?
---@param winnr       integer
---@param breadcrumbs string[]
local function handle_lsp_symbols(err, symbols, winnr, breadcrumbs)
  if not vim.api.nvim_win_is_valid(winnr) then
    return
  end
  -- Always show at minimum the file path; append symbol context when available.
  local crumbs = vim.list_extend({}, breadcrumbs)
  if not err and symbols then
    local pos = vim.api.nvim_win_get_cursor(winnr)
    find_symbol_path(symbols, pos[1] - 1, pos[2], crumbs)
  end
  apply_winbar(crumbs, winnr)
end

-- ---------------------------------------------------------------------------
-- Tree-sitter path
-- ---------------------------------------------------------------------------

---@param bufnr       integer
---@param winnr       integer
---@param breadcrumbs string[]
local function breadcrumbs_from_ts(bufnr, winnr, breadcrumbs)
  local cursor = vim.api.nvim_win_get_cursor(winnr)
  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr = bufnr,
    pos = { cursor[1] - 1, cursor[2] },
    ignore_injections = false,
  })

  local crumbs = vim.list_extend({}, breadcrumbs)

  if ok and node then
    -- Walk ancestors from cursor outward, collecting named scope nodes.
    -- Prepend so the resulting list is outermost → innermost.
    local scopes = {}
    local current = node:parent()
    while current do
      local kind = ts_scope_kinds[current:type()]
      if kind then
        local name = extract_scope_name(current, bufnr)
        if name then
          table.insert(scopes, 1, { kind = kind, name = name })
        end
      end
      current = current:parent()
    end

    for _, scope in ipairs(scopes) do
      local icon = get_icon("lsp", scope.kind)
      table.insert(crumbs, (icon ~= "" and icon .. " " or "") .. scope.name)
    end
  end

  apply_winbar(crumbs, winnr)
end

-- ---------------------------------------------------------------------------
-- Dispatch
-- ---------------------------------------------------------------------------

local function breadcrumbs_set()
  if not _G.Breadcrumbs.config.enabled then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()

  local uri = vim.lsp.util.make_text_document_params(bufnr).uri
  if not uri or uri:sub(1, (uri:find(":") or 1) - 1) ~= "file" then
    vim.api.nvim_set_option_value("winbar", "", { win = winnr })
    return
  end

  -- Find the first attached client that can produce document symbols.
  local lsp_client
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c:supports_method("textDocument/documentSymbol") then
      lsp_client = c
      break
    end
  end

  local breadcrumbs = {}

  if lsp_client then
    lsp_client:request(
      "textDocument/documentSymbol",
      { textDocument = { uri = uri } },
      function (err, symbols)
        handle_lsp_symbols(err, symbols, winnr, breadcrumbs)
      end,
      bufnr
    )
  else
    breadcrumbs_from_ts(bufnr, winnr, breadcrumbs)
  end
end

-- ---------------------------------------------------------------------------
-- Debounce
-- ---------------------------------------------------------------------------

---@type uv.uv_timer_t?
local debounce_timer = nil

function M.debounced_breadcrumbs_set()
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end
  local t = vim.uv.new_timer()
  if not t then
    return
  end
  debounce_timer = t
  t:start(
    200, 0,
    vim.schedule_wrap(function ()
      t:close()
      if debounce_timer == t then
        debounce_timer = nil
        breadcrumbs_set()
      end
    end)
  )
end

-- ---------------------------------------------------------------------------
-- Toggle
-- ---------------------------------------------------------------------------

function M.toggle_breadcrumbs()
  if _G.Breadcrumbs == nil then
    vim.notify("`Breadcrumbs` doesn't exist!", vim.log.levels.WARN, { title = "LSP" })
    return
  end

  _G.Breadcrumbs.config.enabled = not _G.Breadcrumbs.config.enabled
  if _G.Breadcrumbs.config.enabled then
    vim.notify("Breadcrumbs enabled", vim.log.levels.INFO, { title = "LSP" })
    M.debounced_breadcrumbs_set()
  else
    vim.notify("Breadcrumbs disabled", vim.log.levels.INFO, { title = "LSP" })
    vim.o.winbar = ""
  end
end

-- ============================================================================
-- Setup
-- ============================================================================

_G["Breadcrumbs"] = { config = { enabled = true } }

vim.keymap.set("n", [[\B]], M.toggle_breadcrumbs, {
  desc = "Toggle LSP breadcrumbs",
  noremap = false,
  silent = true,
})

return M
