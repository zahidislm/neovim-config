local wk = require("which-key")

local M = {}

function M.rename()
	if pcall(require, "inc_rename") then
		return ":IncRename " .. vim.fn.expand("<cword>")
	else
		vim.lsp.buf.rename()
	end
end

function M.setup(client, buffer)
	local cap = client.server_capabilities

	local keymap = {
		buffer = buffer,
		["<Leader>"] = {
			c = {
				name = "+code",
				a = {
					{ vim.lsp.buf.code_action, "Code Action" },
					{ "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action", mode = "v" },
				},
				f = {
					{
						require("plugins.lang-server.utils.formatting").format,
						"Format Document",
						cond = cap.documentFormattingProvider,
					},
					{
						require("plugins.lang-server.utils.formatting").format,
						"Format Range",
						cond = cap.documentRangeFormattingProvider,
						mode = "v",
					},
				},
				r = {
					M.rename,
					"Rename object under cursor",
					cond = cap.renameProvider,
					expr = true,
				},
				d = { "<Cmd>Telescope diagnostics<CR>", "Search Diagnostics" },
				l = {
					name = "+lsp",
					i = { "<Cmd>LspInfo<CR>", "Lsp Info" },
					a = { "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
					r = { "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
					l = { "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Folders" },
					s = { "<Cmd>Telescope lsp_document_symbols<CR>", "Toggles LSP Symbol View" },
				},
			},
			f = {
				rf = { "<Cmd>Telescope lsp_references<CR>", "References" },
			},
		},
		g = {
			name = "+goto",
			d = { "<Cmd>Telescope lsp_definitions<CR>", "Goto Definition" },
			D = { "<Cmd>Telescope lsp_declarations<CR>", "Goto Declaration" },
			I = { "<Cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
			t = { "<Cmd>Telescope lsp_type_definitions<CR>", "Goto Type Definition" },
		},
		["<C-k>"] = { "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help", mode = { "n", "i" } },
		["K"] = {
			function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end,
			"LSP Hover",
		},
	}

	wk.register(keymap)
end

return M
