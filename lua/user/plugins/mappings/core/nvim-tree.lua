-- Toggle tree view
map("n", "<Leader>tt", "<cmd>NvimTreeToggle<CR>", s_opts)

-- Focus to the tree
map("n", "<Leader>tf", "<cmd>NvimTreeFocus<CR>", s_opts)

-- Refreshes tree
map("n", "<Leader>tr", "<cmd>NvimTreeRefresh<CR>", s_opts)

-- Collapses open tree nodes
map("n", "<Leader>tc", "<cmd>NvimTreeCollapseKeepBuffers<CR>", s_opts)
