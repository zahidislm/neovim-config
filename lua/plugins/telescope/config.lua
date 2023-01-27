local actions = require("telescope.actions")
local utils = require("plugins.telescope.utils")

return {
	defaults = {
		-- Layout Style Config
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		-- Border & Icons
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		entry_prefix = "  ",
		prompt_prefix = "  ",
		selection_caret = "  ",
		-- Strategies
		sorting_strategy = "ascending",
		set_env = { COLORTERM = "truecolor" },
		file_ignore_patterns = utils.ignore_patterns,
		shorten_path = true,
		preview = { treesitter = false },

		mappings = {
			i = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Esc>"] = actions.close,
			},

			n = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},

	pickers = {
		find_files = utils.dropdown(),
		oldfiles = utils.dropdown({ prompt_title = "Recent Files" }),
		git_files = utils.dropdown(),
		buffers = {
			show_all_buffers = true,
			sort_lastused = true,
			scroll_strategy = "limit",
			theme = "dropdown",
			previewer = false,
			mappings = {
				i = { ["<M-d>"] = "delete_buffer" },
				n = { ["<M-d>"] = "delete_buffer" },
			},
		},

		lsp_definitions = {
			theme = "cursor",
			jump_type = "never",
		},

		lsp_references = {
			theme = "cursor",
		},

		diagnostics = {
			theme = "ivy",
			layout_config = {
				height = 0.45,
			},
		},
	},

	extensions = {
		file_browser = {
			grouped = true,
		},
	},
}
