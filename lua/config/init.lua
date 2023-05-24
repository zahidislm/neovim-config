-- Load core modules
require("config.options")
require("config.lang")
require("config.ui")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")
	end,
})
