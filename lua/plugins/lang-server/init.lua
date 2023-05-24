return {
	{
		"neovim/nvim-lspconfig",
		name = "lsp",
		event = "BufReadPre",
		version = false,
		dependencies = { "mason-lsp" },
		opts = function()
			return require("plugins.lang-server.config.opts")
		end,
		config = function(_, opts)
			require("plugins.lang-server.config").setup(opts)
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason-lsp",
		dependencies = {
			"williamboman/mason.nvim",
			name = "mason",
			config = true,
		},
		opts = {
			ensure_installed = SERVERS,
			automatic_installation = true,
		},
	},

	{
		"smjonas/inc-rename.nvim",
		dependencies = { "lsp" },
		cmd = "IncRename",
		opts = { input_buffer_type = "dressing" },
	},
}
