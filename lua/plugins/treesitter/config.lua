return {
	ensure_installed = PARSERS,
	sync_install = false,

	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 750 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},

	textsubjects = {
		enable = true,
		prev_selection = ",", -- (Optional) keymap to select the previous selection
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
			["i;"] = "textsubjects-container-inner",
		},
	},

	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
	},

	refactor = {
		highlight_definitions = {
			enable = true,
			clear_on_cursor_move = true,
		},

		smart_rename = {
			enable = true,
			client = {
				smart_rename = "<leader>sr",
			},
		},
	},
}
