return {
	"utilyre/barbecue.nvim",
	event = "BufReadPost",
	dependencies = { "SmiteshP/nvim-navic" },
	opts = {
		show_modified = true,
		create_autocmd = false,
	},
	config = function(_, opts)
		require("barbecue").setup(opts)

		vim.api.nvim_create_autocmd({
			"WinScrolled",
			"BufWinEnter",
			"CursorHold",
			"InsertLeave",
			"BufModifiedSet",
		}, {
			group = vim.api.nvim_create_augroup("barbecue.updater", {}),
			callback = function()
				require("barbecue.ui").update()
			end,
		})
	end,
}
