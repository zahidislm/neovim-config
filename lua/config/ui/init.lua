-- UI ICONS
require("config.ui.icons")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- custom status column w/ gitsigns & LSP diagnostics
		require("config.ui.statuscolumn")
	end,
})
