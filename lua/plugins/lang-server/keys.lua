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
		["c"] = {
			A = {
				M.rename,
				"Rename lsp object under cursor",
				cond = cap.renameProvider,
				expr = true,
				mode = { "n", "v" },
			},
		},
		["<Leader>"] = {
			c = {
				name = "+code",
				a = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action", mode = { "n", "v" } },
				f = {
					{
						"<Cmd>GuardFmt<CR>",
						"Format Document",
						cond = cap.documentFormattingProvider,
					},
					{
						"<Cmd>GuardFmt<CR>",
						"Format Range",
						cond = cap.documentRangeFormattingProvider,
						mode = "v",
					},
				},
				d = { "<Cmd>FzfLua diagnostics_document<CR>", "Search Diagnostics <current file>" },
				D = { "<Cmd>FzfLua diagnostics_workspace<CR>", "Search Diagnostics <workspace>" },
			},
		},
		g = {
			name = "+goto",
			R = { "<Cmd>Glance references<CR>", "References" },
			D = { "<Cmd>Glance definitions<CR>", "Goto Definition" },
			I = { "<Cmd>Glance implementations<CR>", "Goto Implementation" },
			T = { "<Cmd>Glance type_definitions<CR>", "Goto Type Definition" },
		},
		K = {
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
