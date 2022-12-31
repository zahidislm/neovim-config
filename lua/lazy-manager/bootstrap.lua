local M = {}

function M.setup()
	-- Bootstrap lazy.nvim package manager
	local lazypath = DATA_PATH .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
	end

	vim.opt.runtimepath:prepend(lazypath)
end

return M
