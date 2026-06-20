local snippet_registry = {}

-------------------------------------------------------------------------------
-- Snippet Registration
-------------------------------------------------------------------------------
--- Register one or more snippets for the current buffer's filetype.
---@param snippets table<string, string> map of trigger -> snippet body
local function add(snippets)
  local ft = vim.bo.filetype
  local registry = snippet_registry[ft]
  if not registry then
    registry = {}
    snippet_registry[ft] = registry
  end
  for trigger, body in pairs(snippets) do
    registry[trigger] = body
  end
end

-------------------------------------------------------------------------------
-- Completion integration
-------------------------------------------------------------------------------
--- Build LSP-completion-item-shaped entries for the current buffer's filetype.
---@param base string current completion base (typed prefix)
---@return table[] items shaped like LSP `CompletionItem`s
local function get_items(base)
  local ft = vim.bo.filetype
  local snippets = snippet_registry[ft]
  if not snippets then return {} end

  local active_clients = vim.lsp.get_clients({ bufnr = 0 })
  local fallback_client_id = active_clients[1] and active_clients[1].id

  local items = {}
  for trigger, body in pairs(snippets) do
    if vim.startswith(trigger, base) then
      table.insert(items, {
        label = trigger,
        insertText = body,
        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
        client_id = fallback_client_id,
        documentation = {
          kind = "markdown",
          value = string.format("```%s\n%s\n```", ft ~= "" and ft or "text", body),
        },
      })
    end
  end
  return items
end

_G["vimsnip"] = { add = add, get_items = get_items }
