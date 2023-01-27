return {

	-- Single Buffer
	{ "<Leader>rs", "<Cmd>SearchReplaceSingleBufferSelections<CR>", desc = "Search & Replace w/ UI" },
	{ "<Leader>ro", "<Cmd>SearchReplaceSingleBufferOpen<CR>", desc = "Search & Replace" },
	{ "<Leader>rw", "<Cmd>SearchReplaceSingleBufferCWord<CR>", desc = "Replace cursored word" },
	{ "<Leader>rW", "<Cmd>SearchReplaceSingleBufferCWORD<CR>", desc = "Replace entire word" },
	{ "<Leader>re", "<Cmd>SearchReplaceSingleBufferCExpr<CR>", desc = "Replace word w/ expr" },
	{ "<Leader>rf", "<Cmd>SearchReplaceSingleBufferCFile<CR>", desc = "Replace file name" },

	-- Multi Buffers
	{ "<Leader>rbs", "<Cmd>SearchReplaceMultiBufferSelections<CR>", desc = "Search & Replace w/ UI" },
	{ "<Leader>rbo", "<Cmd>SearchReplaceMultiBufferOpen<CR>", desc = "Search & Replace" },
	{ "<Leader>rbo", "<Cmd>SearchReplaceMultiBufferCWord<CR>", desc = "Replace cursored word" },
	{ "<Leader>rbW", "<Cmd>SearchReplaceMultiBufferCWORD<CR>", desc = "Replace entire word" },
	{ "<Leader>rbe", "<Cmd>SearchReplaceMultiBufferCExpr<CR>", desc = "Replace word w/ expr" },
	{ "<Leader>rbf", "<Cmd>SearchReplaceMultiBufferCFile<CR>", desc = "Replace file name" },

	-- Visual Mode
	{ "<C-r>", "<Cmd>SearchReplaceSingleBufferVisualSelection<CR>", mode = "v" },
	{ "<C-s>", "<Cmd>SearchReplaceWithinVisualSelection<CR>", mode = "v" },
	{ "<C-b>", "<Cmd>SearchReplaceWithinVisualSelectionCWord<CR>", mode = "v" },
}
