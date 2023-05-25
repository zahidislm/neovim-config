local function is_virtual_line()
	return vim.v.virtnum < 0
end

local function is_wrapped_line()
	return vim.v.virtnum > 0
end

local function not_in_fold_range()
	return vim.fn.foldlevel(vim.v.lnum) <= 0
end

local function not_fold_start(line)
	line = line or vim.v.lnum
	return vim.fn.foldlevel(line) <= vim.fn.foldlevel(line - 1)
end

local function fold_opened(line)
	return vim.fn.foldclosed(line or vim.v.lnum) == -1
end

local function get_signs()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
	return vim.tbl_map(function(sign)
		return vim.fn.sign_getdefined(sign.name)[1]
	end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

local function line_number()
	local lnum = tostring(vim.v.lnum)
	if is_virtual_line() then
		return string.rep(" ", #lnum)
	elseif is_wrapped_line() then
		return ICONS.misc.next_line .. string.rep(" ", #lnum)
	else
		return (#lnum == 1 and " " or "") .. lnum
	end
end

local function fold_icon()
	if is_wrapped_line() or is_virtual_line() then
		return ""
	end

	local icon
	if not_in_fold_range() or not_fold_start() then
		icon = "  "
	elseif fold_opened() then
		icon = ICONS.misc.expanded
	else
		icon = ICONS.misc.collapsed
	end

	return icon
end

local highlights_cache = {}

local function border_highlight(sign)
	if sign then
		if not highlights_cache[sign.name] then
			highlights_cache[sign.name] = vim.fn.sign_getdefined(sign.name)[1].texthl
		end

		return highlights_cache[sign.name]
	else
		return "StatusColumnBorder"
	end
end

local border = function()
	local signs = get_signs()
	local git_sign
	if next(signs) then
		local last_sign = signs[#signs]
		if last_sign.name:find("GitSign") then
			git_sign = last_sign
		end
	end

	return { git_sign and ("%#" .. border_highlight(git_sign) .. "#" .. ICONS.misc.v_border .. "%*") }
end

local diagnostic = function() -- TODO: rank by severity
	local sign
	for _, s in ipairs(get_signs()) do
		if not s.name:find("GitSign") then
			sign = s
		end
	end

	return { sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") }
end

local number = function()
	return { " %=", line_number(), " " }
end

local fold = function()
	return { "%#FoldColumn#", "%@v:lua.StatusColumn.fold_click_handler@", fold_icon() }
end

local padding = function()
	if vim.v.lnum == vim.fn.getcurpos()[2] then
		return { "%#StatusColumnBufferCursorLine#", " " }
	else
		return { "%#StatusColumnBuffer#", " " }
	end
end

if _G.StatusColumn then
	return
end

_G.StatusColumn = {}

StatusColumn.fold_click_handler = function()
	local line = vim.fn.getmousepos().line

	if not_fold_start(line) then
		return
	end

	vim.cmd.execute("'" .. line .. "fold" .. (fold_opened(line) and "close" or "open") .. "'")
end

StatusColumn.set_window = function(value, defer, win)
	vim.defer_fn(function()
		win = win or vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_option(win, "statuscolumn", value)
	end, defer or 1)
end

StatusColumn.build = function()
	return table.concat(vim.tbl_flatten({ border(), diagnostic(), number(), fold(), padding() }))
end

vim.opt.statuscolumn = "%{%v:lua.StatusColumn.build()%}"
