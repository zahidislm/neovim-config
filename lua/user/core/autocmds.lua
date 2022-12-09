local reg_auto = require("legendary").autocmds

local augroups = {
	{
		name = "UpdateFile",
		{
			{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
			function()
				local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
				local mode = vim.api.nvim_get_mode()["mode"]
				if (not regex:match_str(mode)) and vim.fn.getcmdwintype() == "" then
					vim.cmd("checktime")
				end
			end,
			description = "If the file is changed outside of neovim, reload it automatically.",
		},
		{
			"FileChangedShellPost",
			function()
				vim_notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
			end,
			description = "If the file is changed outside of neovim, reload it automatically.",
		},
	},
	{
		"BufEnter",
		[[silent! lcd %:p:h]],
		opts = { pattern = { "*.*" } },
		description = "Set the parent directory of the current file as cwd.",
	},
	{
		"BufWritePre",
		function()
			perform_cleanup()
		end,
		description = "Remove trailing whitespace and newlines on save.",
	},
	{
		"TextYankPost",
		function()
			vim.highlight.on_yank({
				higroup = "Visual",
				timeout = 500,
				on_visual = true,
				on_macro = true,
			})
		end,
		description = "Remove trailing whitespace and newlines on save.",
	},
	{
		"BufReadPost",
		[[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"zz" | endif]],
		description = "Restore cursor position to last known position on read",
	},
}

reg_auto(augroups)
