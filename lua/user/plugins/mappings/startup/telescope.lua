-- ------------------------------ CORE Telescope ----------------------------- --

-- Open main Telescope window
kmap { key = "to", cmd = "<cmd>Telescope<CR>" }

-- Opens file browser
kmap { key = "fb", cmd = "<cmd>Telescope file_browser<CR>" }

-- Lists buffers
kmap { key = "tt", cmd = "<cmd>Telescope buffers<CR>" }

-- Greps within current working dir
kmap { key = "tg", cmd = "<cmd>Telescope live_grep<CR>" }

-- Gets git status for all files in scope
kmap { key = "ts", cmd = "<cmd>Telescope git_status<CR>" }

-- ------------------------------ LSP & Telescope ----------------------------- --

-- Goto the definition of the word under the cursor
kmap { key = "gd", cmd = "<cmd>Telescope lsp_definitions<CR>" }

-- Lists LSP references for word under the cursor
kmap { key = "gr", cmd = "<cmd>Telescope lsp_references<CR>" }

-- Goto the implementation of the word under the cursor
kmap { key = "gi", cmd = "<cmd>Telescope lsp_implementations<CR>" }

-- Lists LSP document symbols in the current buffering
kmap { key = "gs", cmd = "<cmd>Telescope lsp_document_symbols<CR>" }

-- ------------------------------ Telescope Utilities ----------------------------- --
kmap { key = "tf", cmd = function()
    require(P_CONFIGS .. "startup.telescope.sources").git_or_find()
end }

kmap { key = "tn", cmd = function()
    require(P_CONFIGS .. "startup.telescope.sources").dir_nvim()
end }

kmap { key = "<F5>", cmd = function()
    require(P_CONFIGS .. "startup.telescope.sources").reload_modules()
end }

kmap { key = "<F6>", cmd = function()
    require(P_CONFIGS .. "startup.telescope.sources").dir_plugins()
end }
