local M = {}

local function fzf_nvimconfig()
	-- specify vimconfig directory
	local choice = "~/.config/nvim"
	require("fzf-lua").files({
		cwd = choice,
	})
	vim.cmd("chdir " .. choice)
end

local function fzf_dotfiles()
	-- this is using dropbox, you can use your git dir
	local choice = "~/dotfiles/"
	require("fzf-lua").files({
		cwd = choice,
	})
	vim.cmd("chdir " .. choice)
end

local function core_keys()
	local keys = {
		-- Git pickers
		{ "<Leader>gb", "<Cmd>FzfLua git_branches<CR>", desc = "branches" },
		{ "<Leader>gc", "<Cmd>FzfLua git_bcommits<CR>", desc = "file commits" },
		{ "<Leader>gC", "<Cmd>FzfLua git_commits<CR>", desc = "project commits" },
		{ "<Leader>gs", "<Cmd>FzfLua git_status<CR>", desc = "status" },

		-- Search pickers
		{ "<Leader>sb", "<Cmd>FzfLua grep_curbuf<CR>", desc = "Search current buffer" },
		{ "<Leader>sg", "<Cmd>FzfLua live_grep_native cwd=%:p:h<CR>", desc = "Grep (cwd)" },
		{ "<Leader>sG", "<Cmd>FzfLua live_grep_native<CR>", desc = "Grep (workspace)" },
		{ "<Leader>sh", "<Cmd>FzfLua command_history<CR>", desc = "Command History" },
		{ "<Leader>sm", "<Cmd>FzfLua marks<CR>", desc = "Jump to mark" },
		{ "<Leader>ss", "<Cmd>FzfLua lsp_document_symbols<CR>", desc = "Goto LSP symbol" },
		{ "<Leader>sS", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Goto LSP symbol (workspace)" },
		{ "<Leader>sq", "<Cmd>FzfLua quickfix<CR>", desc = "Fuzzy search in quickfix" },

		-- File Explorer
		{ "<Leader>ff", "<Cmd>FzfLua files<CR>", desc = "Search for file" },
		{
			"<Leader>sD",
			function()
				return fzf_dotfiles()
			end,
			desc = "Search through dotfiles",
		},
		{
			"<Leader>sN",
			function()
				return fzf_nvimconfig()
			end,
			desc = "Search through Neovim config",
		},
		{ "<Leader>fr", "<Cmd>FzfLua oldfiles<CR>", desc = "Open recent files" },

		-- Buffer management
		{ "<Leader>bb", "<Cmd>FzfLua buffers<CR>", desc = "List all open buffers" },
	}

	return keys
end

function M.setup(mod)
	mod = type(mod) == "string" and mod or "core"

	return core_keys()
end

return M
