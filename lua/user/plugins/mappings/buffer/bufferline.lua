-- Pick between open buffers
map("n", "bfp", "<cmd>BufferLinePick<CR>", s_opts)

-- Close a current buffer
map("n", "bfc", "<cmd>BufferLinePickClose<CR>", s_opts)

-- Goto buffer that's visible
map("n", "<Leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", s_opts)
map("n", "<Leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", s_opts)
map("n", "<Leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", s_opts)
map("n", "<Leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", s_opts)
map("n", "<Leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", s_opts)
map("n", "<Leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", s_opts)
map("n", "<Leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", s_opts)
map("n", "<Leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", s_opts)
map("n", "<Leader>$", "<Cmd>BufferLineGoToBuffer -1<CR>", s_opts)

-- Cycle through buffers
map("n", "]b", "<Cmd>BufferLineCycleNext<CR>", s_opts)
map("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", s_opts)
