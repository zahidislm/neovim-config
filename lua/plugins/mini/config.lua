return {
	ai = {
		dependencies = { "treesitter", "treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
	},

	indentscope = {
		version = false,
		event = "BufReadPre",
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
	},

	move = { version = false },
	pairs = { event = "InsertEnter" },
	sessions = { event = "VeryLazy" },
	surround = {
		keys = function(plugin, keys)
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			local mappings = {
				{ opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete surrounding" },
				{ opts.mappings.find, desc = "Find right surrounding" },
				{ opts.mappings.find_left, desc = "Find left surrounding" },
				{ opts.mappings.highlight, desc = "Highlight surrounding" },
				{ opts.mappings.replace, desc = "Replace surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			return vim.list_extend(mappings, keys)
		end,

		opts = {
			mappings = {
				add = "ba", -- Add surrounding in Normal and Visual modes
				delete = "bd", -- Delete surrounding
				find = "bf", -- Find surrounding (to the right)
				find_left = "bF", -- Find surrounding (to the left)
				highlight = "bh", -- Highlight surrounding
				update_n_lines = "bn", -- Update `n_lines`
				replace = "br", -- Replace surrounding
			},
		},
	},
}
