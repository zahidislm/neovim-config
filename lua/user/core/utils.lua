--- Trim newline at eof, trailing whitespace.
function _G.perform_cleanup()
	local patterns = {
		-- Remove leading empty lines
		[[%s/\%^\n//e]],
		-- Remove trailing empty lines
		[[%s/$\n\+\%$//e]],
		-- Remove trailing spaces
		[[%s/\s\+$//e]],
		-- Remove trailing "\r"
		[[%s/\r\+//e]],
	}

	local view = vim.fn.winsaveview()

	for _, v in pairs(patterns) do
		vim.cmd(string.format("keepjumps keeppatterns silent! %s", v))
	end

	vim.fn.winrestview(view)
end

-- Reloading lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
if pcall(require, "plenary") then
	local reload = require("plenary.reload").reload_module
	--- Reload module using plenary
	--- @param name string module
	function _G.plenary_reload(name)
		reload(name)
	end
end

--- Quickfix toggle
--- https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
vim.api.nvim_create_user_command("QFix", function(bang)
	if vim.fn.getqflist({ winid = 0 }).winid ~= 0 and bang then
		vim.cmd("cclose")
	else
		vim.cmd("copen 10")
	end
end, {
	nargs = "?",
	bang = true,
	force = true,
})

--- Redraw before notifying
---@param msg string Content of the notification to show to the user.
---@param level number|nil One of the values from vim.log.levels.
function _G.vim_notify(msg, level)
	vim.cmd("redraw")
	vim.notify(msg, level)
end

function _G.exists_and_not_nil(t)
	if t then
		return next(t) ~= nil
	end
	return false
end
