local actions = require("telescope.actions")
local utils = require("plugins.telescope.utils")
local icons = vim.g.ui_icons

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
			width = 0.85,
			height = 0.80,
			preview_cutoff = 120,
		},

		-- Global options
		wrap_results = true,
		results_title = false,

		-- Border & Icons
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		entry_prefix = "  ",
		prompt_prefix = icons.misc.prompt,
		selection_caret = icons.misc.select,
		-- Strategies
		sorting_strategy = "ascending",
		set_env = { COLORTERM = "truecolor" },
		file_ignore_patterns = utils.ignore_patterns,
		preview = { treesitter = false },
		path_display = {
			shorten = {
				len = 1,
				exclude = { 1, -1, -2 },
			},
		},

		mappings = {
			i = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Esc>"] = actions.close,
				["<C-s>"] = require("telescope.actions.layout").toggle_preview,
				["<M-x>"] = actions.select_horizontal,
				["<M-v>"] = actions.select_vertical,
			},

			n = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-s>"] = require("telescope.actions.layout").toggle_preview,
			},
		},
	},

	pickers = {
		find_files = utils.dropdown(),
		live_grep = utils.dropdown(),
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

		diagnostics = {
			theme = "ivy",
			preview_title = false,
			layout_config = {
				height = 0.45,
			},
		},
	},

	extensions = {
		["ui-select"] = { require("telescope.themes").get_dropdown() },

		file_browser = {
			grouped = true,
			wrap_results = false,
			prompt_title = false,
			preview_title = false,
		},
	},
}
