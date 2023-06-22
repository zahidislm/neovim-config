return {
	{
		"kevinhwang91/nvim-treesitter",
		name = "treesitter",
		opts = function()
			return require("plugins.treesitter.config")
		end,
		config = function(_, opts)
			return require("nvim-treesitter.configs").setup(opts)
		end,
		build = ":TSUpdate",
		keys = {
			{ "<Enter>", desc = "Increment selection" },
			{ "<BS>", desc = "Shrink selection", mode = "x" },
		},
		module = false,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		name = "treesitter-textobjects",
		init = function()
			-- no need to load the plugin, since we only need its queries
			require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
		end,
	},
}
