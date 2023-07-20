return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- snippet engine
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy",

			-- sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"FelipeLema/cmp-async-path",

			-- misc
			"onsails/lspkind.nvim",
		},
		opts = function()
			return require("plugins.completion.config")
		end,
		version = false,
	},

	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "fzf", "vim" },
		},
		config = function(_, opts)
			local autopairs = require("nvim-autopairs")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			autopairs.setup(opts)
			autopairs.add_rules({
				rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(move_opts)
					return move_opts.char == ">"
				end),
			})

			-- setup cmp for autopairs
			local has_cmp, cmp = pcall(require, "cmp")
			if has_cmp then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
		event = "InsertEnter",
	},
}
