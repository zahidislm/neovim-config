-- Load core modules
require("config.options")
require("config.lang")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")
		require("config.ui")
		vim.opt.listchars:append(ICONS.listchars)
	end,
})
