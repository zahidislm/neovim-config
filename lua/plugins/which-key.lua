return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
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
				["<Leader>s"] = { name = "+search" },
				["<Leader>t"] = { name = "+terminal" },
				["<Leader>w"] = { name = "+window" },
				["<Leader>r"] = { name = "+replace" },
				["<Leader>rb"] = { name = "+buffers-multi" },
			})
		end,
	},
}
