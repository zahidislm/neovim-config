local suffix_icon = "⇞ "

return function(virt_text, lnum, end_lnum, width, truncate, ctx)
	local new_virt_text = {}
	local suffix = (" " .. suffix_icon .. "%d "):format(end_lnum - lnum)
	local suffix_width = vim.fn.strdisplaywidth(suffix)
	local target_width = width - suffix_width
	local curr_width = 0
	for chunk = 1, #virt_text do
		local chunk_text = virt_text[chunk][1]
		local chunk_width = vim.fn.strdisplaywidth(chunk_text)
		if target_width > curr_width + chunk_width then
			new_virt_text[#new_virt_text + 1] = virt_text[chunk]
		else
			chunk_text = truncate(chunk_text, target_width - curr_width)
			local hl_group = virt_text[chunk][2]
			new_virt_text[#new_virt_text + 1] = { chunk_text, hl_group }
			chunk_width = vim.fn.strdisplaywidth(chunk_text)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curr_width + chunk_width < target_width then
				suffix = suffix .. (" "):rep(target_width - curr_width - chunk_width)
			end
			break
		end

		curr_width = curr_width + chunk_width
	end

	new_virt_text[#new_virt_text + 1] = { suffix, "MoreMsg" }

	if vim.bo.filetype ~= "python" then
		local end_virt_text = ctx.get_fold_virt_text(end_lnum)
		if string.find(end_virt_text[1][2], "UfoFoldedFg") then
			table.remove(end_virt_text, 1)
		end

		new_virt_text = vim.list_extend(new_virt_text, end_virt_text)
	end

	return new_virt_text
end
