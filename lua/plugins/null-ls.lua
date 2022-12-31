local M = {
	"jay-babu/mason-null-ls.nvim",
	event = "BufReadPost",
	dependencies = {
		"williamboman/mason.nvim",
		{
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("null-ls").setup({
					debounce = 150,
					save_after_format = false,
				})
			end,
		},
	},
}

function M.config()
	require("mason-null-ls").setup({
		ensure_installed = FORMATTERS,
		automatic_installation = false,
		automatic_setup = true,
	})

	require("mason-null-ls").setup_handlers()
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
