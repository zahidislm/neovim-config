local util = require("utils")
local lsp_symbols = {
	"Class",
	"Function",
	"Method",
	"Constructor",
	"Interface",
	"Module",
	"Struct",
	"Trait",
	"Field",
	"Property",
}

return {
	-- Git pickers
	{ "<Leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "commits" },
	{ "<Leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "branches" },
	{ "<Leader>gs", "<Cmd>Telescope git_status<CR>", desc = "status" },

	-- Search pickers
	{ "<Leader>sg", util.telescope("live_grep"), desc = "Grep (cwd)" },
	{ "<Leader>sG", util.telescope("live_grep", { cwd = false }), desc = "Grep (root)" },
	{ "<Leader>sb", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffers" },
	{ "<Leader>ss", util.telescope("lsp_document_symbols<CR>", { symbols = lsp_symbols }), desc = "Goto LSP symbol" },
	{ "<Leader>sh", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
	{ "<Leader>sm", "<Cmd>Telescope marks<CR>", desc = "Jump to mark" },

	-- File Explorer
	{ "<Leader>ff", util.telescope("files"), desc = "Find file (cwd)" },
	{ "<Leader>fF", util.telescope("files", { cwd = false }), "Find file (root)" },
	{ "<Leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Open recent files" },
	{ "<Leader>fb", "<Cmd>Telescope file_browser path=%:p:h<CR>", desc = "Opens file browser (cwd)" },
	{ "<Leader>fB", "<Cmd>Telescope file_browser<CR>", desc = "Opens file browser (root)" },

	-- Buffer management
	{ "<Leader>bb", "<Cmd>Telescope buffers<CR>", desc = "List all open buffers" },
}
