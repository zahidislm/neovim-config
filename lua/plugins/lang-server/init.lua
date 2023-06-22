return {
	{
		"neovim/nvim-lspconfig",
		name = "lsp",
		dependencies = { "UI", "mason-lsp" },
		opts = function()
			return require("plugins.lang-server.config.opts")
		end,
		config = function(_, opts)
			require("plugins.lang-server.config").setup(opts)
		end,
		version = false,
		event = "BufReadPre",
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
		config = true,
		cmd = "IncRename",
	},

	{
		"dnlhc/glance.nvim",
		dependencies = { "lsp" },
		opts = { height = 15 },
		cmd = "Glance",
	},
}
