return {
	ensure_installed = PARSERS,

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

	indent = { enable = true },

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Enter>",
			node_incremental = "<Enter>",
			scope_incremental = "<NOP>",
			node_decremental = "<BS>",
		},
	},
}
