-- Show declaration of the word under the cursor
kmap { key = "gD", cmd = ":lua vim.lsp.buf.declaration()<CR>" }

-- Lists any LSP actions for the word under the cursor
kmap { key = "ca", cmd = ":lua vim.lsp.buf.code_action()<CR>" }

-- Show hover window
kmap { key = "K", cmd = ":lua vim.lsp.buf.hover()<CR>" }

-- Jump to previous diagnostic
kmap { key = "[g", cmd = ":lua vim.lsp.diagnostic.goto_prev()<CR>" }

-- Jump to next diagnostic
kmap { key = "]g", cmd = ":lua vim.lsp.diagnostic.goto_next()<CR>" }
