-- Cycle thru LSP diagnostics
map("n", "[d", "<cmd>vim.diagnostic.goto_prev<CR>", b_b_opts)
map("n", "d]", "<cmd>vim.diagnostic.goto_next<CR>", b_b_opts)

-- Open floating window for LSP diagnostics
map("n", "gf", function()
    local float_b_opts = {
         focusable = false,
         close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
         border = "single",
         source = "if_many",
         prefix = "",
    }

    vim.diagnostic.open_float(nil, float_b_opts)
end, b_b_opts)

-- Code Actions
map("n", "ga", "<cmd>vim.lsp.buf.code_action<CR>", b_opts)

-- Get definition
map("n", "gd", "<cmd>vim.lsp.buf.definition<CR>", b_opts)

-- Find declaration
map("n", "gD", "<cmd>vim.lsp.buf.declaration<CR>", b_opts)

-- Hover action
map("n", "gh", "<cmd>vim.lsp.buf.hover<CR>", b_opts)

-- Find implementation
map("n", "gi", "<cmd>vim.lsp.buf.implementation<CR>", b_opts)

-- Rename Symbol
map("n", "gr", "<cmd>vim.lsp.buf.rename<CR>", b_opts)

-- Find references
map("n", "gR", "<cmd>vim.lsp.buf.references<CR>", b_opts)

-- Get help w/ LSP signature
map("n", "gs", "<cmd>vim.lsp.buf.signature_help<CR>", b_opts)
