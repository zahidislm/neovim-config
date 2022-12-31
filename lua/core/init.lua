-- Load core modules
require("core.options")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("core.commands")
		require("core.keymaps")
	end,
})
