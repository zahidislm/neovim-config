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
		ft = vim.tbl_keys(SERVERS),
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
			ensure_installed = vim.tbl_flatten(vim.tbl_values(SERVERS)),
			automatic_installation = true,
		},
        build = ":MasonUpdate",
	},

	{
		"nvimdev/guard.nvim",
		dependencies = { "lsp", "mason"},
		opts = {
            fmt_on_save = true,
			lsp_as_default_formatter = true,
			ft = {
				lua = { fmt = { "stylua" } },
				python = { fmt = { "black" } },
				rust = { fmt = { "rustfmt" } },
			},
		},
        build = string.format(":MasonInstall " .. string.rep("%s ", #FORMATTERS), table.unpack(FORMATTERS)),
		ft = vim.tbl_keys(SERVERS),
	},

	-- Utils
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
