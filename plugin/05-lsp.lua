-- Keymap helper
local function keymap(mode, lhs, rhs, bufnr, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
end

--- LSP symbols provided globaly for all lsp clients
---@param bufnr int
local function global_provider(bufnr)
  keymap(
    "n", "gri", "<Cmd>Glance implementations<CR>", bufnr, "Show implementations of the cursorword"
  )

  keymap("n", "grr", "<Cmd>Glance references<CR>", bufnr, "Show references of the cursorword")

  keymap(
    "n", "grt", "<Cmd>Glance type_definitions<CR>", bufnr, "Show type definitions of the cursorword"
  )

  keymap("n", "grO", "<Cmd>Glance definitions<CR>", bufnr, "Show definition of the cursorword")
end

--- Rename symbol provider
---@param client vim.lsp.Client? LSP Client information
---@param bufnr  int Current buffer
local function rename_provider(client, bufnr)
  local caps = client ~= nil and client.server_capabilities or {}

  if caps.renameProvider then
    keymap("n", "grN", function ()
      require("live-rename").rename({ text = "", insert = true })
    end, bufnr, "change LSP symbol"
    )

    keymap("n", "grn", function ()
      require("live-rename").rename()
    end, bufnr, "edit LSP symbol"
    )
  end
end

--- Format provider
---@param client vim.lsp.Client? LSP CLient information 
---@param bufnr int Current buffer
local function format_provider(client, bufnr)
  local caps = client ~= nil and client.server_capabilities or {}

  if caps.documentFormattingProvider then
    local modes = caps.documentRangeFormattingProvider and { "n", "v" } or { "n" }
    keymap(modes, "grf", function ()
      vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
      if vim.fn.exists(":GuessIndent") then vim.cmd("silent GuessIndent") end
    end, bufnr, "format code"
    )
  end
end

-- Global LSP Config
vim.lsp.config("*", { root_markers = { ".git" } })

-- Enables LSP Servers defined in root
local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(f, ":t:r")
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

-- LSP Configuration whenever LSP is attaced.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)

    -- Keymaps
    global_provider(bufnr)
    rename_provider(client, bufnr)
    format_provider(client, bufnr)
  end,
})
