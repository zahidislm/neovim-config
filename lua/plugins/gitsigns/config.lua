return {
	signs = {
		add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = {
			hl = "GitSignsChange",
			text = "▍",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		delete = {
			hl = "GitSignsDelete",
			text = "▸",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		topdelete = {
			hl = "GitSignsDelete",
			text = "▾",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		changedelete = {
			hl = "GitSignsChange",
			text = "▍",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		untracked = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
	},

	on_attach = function(buffer)
		local bufopts = { prefix = "<leader>", buffer = buffer }
		require("plugins.gitsigns.keys").setup(bufopts)
	end,
}
