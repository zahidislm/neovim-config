-- Load core modules
require("config.options")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.commands")
		require("config.keymaps")
	end,
})
