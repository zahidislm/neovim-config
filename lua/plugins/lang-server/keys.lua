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
				a = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action", mode = { "n", "v" } },
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
				d = { "<Cmd>Telescope diagnostics<CR>", "Search Diagnostics" },
				l = {
					name = "+lsp",
					i = { "<Cmd>LspInfo<CR>", "Lsp Info" },
					a = { "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
					r = { "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
					l = { "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Folders" },
				},
			},
			r = {
				M.rename,
				"Rename lsp object under cursor",
				cond = cap.renameProvider,
				expr = true,
				mode = { "n", "v" },
			},
		},
		g = {
			name = "+goto",
			R = { "<Cmd>Glance references<CR>", "References" },
			D = { "<Cmd>Glance definitions<CR>", "Goto Definition" },
			I = { "<Cmd>Glance implementations<CR>", "Goto Implementation" },
			T = { "<Cmd>Glance type_definitions<CR>", "Goto Type Definition" },
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
