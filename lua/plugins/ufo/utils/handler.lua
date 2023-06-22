local suffix_icon = "⇞ "

return function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" " .. suffix_icon .. "%d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for chunk = 1, #virtText do
		local chunkText = virtText[chunk][1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			newVirtText[#newVirtText + 1] = virtText[chunk]
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = virtText[chunk][2]
			newVirtText[#newVirtText + 1] = { chunkText, hlGroup }
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	newVirtText[#newVirtText + 1] = { suffix, "MoreMsg" }
	return newVirtText
end
