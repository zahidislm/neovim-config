local M = {}

M.autoformat = true

function M.format()
	if M.autoformat then
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		else
			vim.lsp.buf.formatting_sync()
		end
	end
end

function M.setup(client, buf)
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	local nls = require("plugins.null-ls")
	local enable = false
	if nls.has_formatter(ft) then
		enable = true
	end

	client.server_capabilities.documentFormattingProvider = enable
	-- format on save
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("plugins.lang-server.formatting").format()
      augroup END
    ]])
	end
end

return M
