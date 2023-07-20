return {
	{
		"folke/which-key.nvim",
		opts = {
			plugins = { spelling = true },
			key_labels = { ["<Leader>"] = "SPC" },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register({
				mode = { "n", "v" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<Leader>b"] = { name = "+buffer" },
				["<Leader>f"] = { name = "+file/find" },
				["<Leader>g"] = { name = "+git" },
				["<Leader>p"] = { name = "+project" },
				["<Leader>q"] = { name = "+quickfix" },
				["<Leader>r"] = { name = "+replace" },
				["<Leader>s"] = { name = "+search" },
				["<Leader>t"] = { name = "+terminal" },
				["<Leader>w"] = { name = "+window" },
			})
		end,
		event = "VeryLazy",
	},
}
