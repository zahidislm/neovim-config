local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("update_file", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
		local mode = vim.api.nvim_get_mode()["mode"]
		if (not regex:match_str(mode)) and vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
	desc = "If the file is changed outside of neovim, reload it automatically.",
	group = group,
	pattern = "*",
})

autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
	end,
	desc = "If the file is changed outside of neovim, reload it automatically.",
	group = group,
	pattern = "*",
})

group = augroup("restore_cur_pos", { clear = true })
autocmd("BufReadPost", {
	command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"zz" | endif]],
	desc = "Restore cursor position to last known position on read.",
	group = group,
	pattern = "*",
})

-- show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})

autocmd("BufWritePre", {
	group = augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match

		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
		local backup = vim.fn.fnamemodify(file, ":p:~:h")
		backup = backup:gsub("[/\\]", "%%")
		vim.go.backupext = backup
	end,
	desc = "create directories when needed, when saving a file.",
})
