local M = {}
local snippet_registry = {}
local is_patched = false

-------------------------------------------------------------------------------
-- Safely hook into mini.completion's item processor
-------------------------------------------------------------------------------
local function ensure_patched()
  if is_patched or type(_G.MiniCompletion) ~= "table" then return end

  _G.MiniCompletion.config = _G.MiniCompletion.config or {}
  _G.MiniCompletion.config.lsp_completion = _G.MiniCompletion.config.lsp_completion or {}

  local orig_process = _G.MiniCompletion.config.lsp_completion.process_items
    or _G.MiniCompletion.default_process_items

  _G.MiniCompletion.config.lsp_completion.process_items = function (items, base)
    local combined_items = vim.list_extend({}, items or {})

    local active_clients = vim.lsp.get_clients({ bufnr = 0 })
    local fallback_client_id = active_clients[1] and active_clients[1].id

    local ft = vim.bo.filetype
    if not ft or ft == "" then ft = "text" end

    for trigger, body in pairs(snippet_registry) do
      if vim.startswith(trigger, base) then
        table.insert(combined_items, {
          label = trigger,
          insertText = trigger,
          kind = 15,
          client_id = fallback_client_id,
          documentation = {
            kind = "markdown",
            value = string.format("```%s\n%s\n```", ft, body),
          },
        })
      end
    end

    return orig_process(combined_items, base)
  end

  is_patched = true
end

-------------------------------------------------------------------------------
-- Snippet Registration
-------------------------------------------------------------------------------
---@param trigger string trigger string for snippet
---@param body string snippet text that will be expanded
---@param opts? vim.keymap.set.Opts
function M.add(trigger, body, opts)
  opts = vim.tbl_deep_extend("force", { buffer = 0 }, opts or {})
  snippet_registry[trigger] = body

  -- Manual insertion mapping for <c-]>
  vim.keymap.set("ia", trigger, function ()
    local raw = vim.fn.getchar(0)
    local c = vim.fn.nr2char(raw)
    if c == "" then
      vim.snippet.expand(body)
    else
      vim.api.nvim_feedkeys(trigger .. c, "i", true)
    end
  end, opts
  )
end

_G["vimsnip"] = { add = M.add }

-------------------------------------------------------------------------------
-- Autocommands (Expansion Hook)
-------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup("CustomSnippetIntegration", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function (args)
    vim.schedule(ensure_patched)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end,
})
