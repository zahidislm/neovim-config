local e_opts = { expr = true }
local se_opts = { silent = true, expr = true }
local kmaps = require("legendary").keymaps

local core = {
	{ ";", ":", description = "Faster command mode", mode = { "n", "v" } },
	{ "x", '"_x', description = "No yank w/ deletion", mode = { "n", "v" } },
	{
		"<leader>rp",
		{
			n = [[:%s/\<<C-r><C-w>\>/]],
			v = [[<Esc>:%s/<C-r>=EscapeString(GetVisualSelection())<CR>/]],
		},
		description = "Replace word under cursor",
	},
	{
		"<C-s>",
		{ n = ":update!<CR>", i = "<Esc><cmd>update!<CR>" },
		description = "Save file",
	},
	{
		"<leader>h",
		"<cmd>nohl<CR>",
		description = "Remove highlights",
	},
	{
		"<C-BS>",
		"<C-w>",
		description = "Delete previous word.",
		mode = "i",
	},
	{
		"C-Del",
		"<C-o>dW",
		description = "Delete next word",
		mode = "i",
	},
	{
		"<leader>tw",
		":setlocal linebreak! wrap!<CR>",
		description = "Toggle code wrapping",
	},
	{
		"<Space>",
		"foldlevel('.') ? 'za' : '<Space>'",
		description = "Toggle code fold block",
		opts = se_opts,
	},
	{
		"<M-[",
		{ n = "<<", x = "<gv" },
		description = "Removes indent",
	},
	{
		"<M-]",
		{ n = ">>", x = ">gv" },
		description = "Adds indent",
	},
	{
		"<M-d>",
		{ n = ":t.<CR>", i = "<Esc>:t.<CR>gi" },
		description = "Duplicates line",
	},
}

local clipboard = {
	{
		"Y",
		'"+yg_',
		description = "Yank til end of line.",
	},
	{
		"y",
		'"+y',
		description = "Always yank to clipboard",
		mode = { "n", "v" },
	},
	{
		"<C-v>",
		{ i = "<C-R><C-o>+", s = "<BS>i<C-R><C-o>+" },
		description = "Paste from system clipboard",
	},
	{
		",p",
		'"0p',
		description = "paste ignoring yank",
		modes = { "n", "v" },
	},
	{
		"cc",
		{
			n = '"_diwP',
			v = '"_d"0P',
		},
		description = "Stamps a yanked text; replacing current text",
	},
}

local window = {
	{ "<leader>sv", "<C-w>v", description = "Split window vertically" },
	{ "<leader>sh", "<C-w>s", description = "Split window horizontally" },
	{ "<leader>sm", "<C-w>| <bar> <C-w>_", description = "Maximize current window" },
	{ "<leader>se", "<C-w>=", description = "Make windows even spilts" },
	{ "<leader>sx", ":close<CR>", description = "Close current window" },
	{ "<C-h>", "<C-w>h", description = "Move to window on left" },
	{ "<C-l>", "<C-w>l", description = "Move to window on right" },
	{ "<C-k>", "<C-w>k", description = "Move to window on top" },
	{ "<C-j>", "<C-w>j", description = "Move to window on bottom" },
}

local movement = {
	{
		"j",
		"v:count == 0 ? 'gj' : 'j'",
		description = "Move down thru code folds",
		opts = e_opts,
	},
	{
		"k",
		"v:count == 0 ? 'gk' : 'k'",
		description = "Move up thru code folds",
		opts = e_opts,
	},
	{
		"<M-j>",
		{
			n = ":m .+1<CR>==",
			i = "<Esc>:m .+1<CR>==gi",
			v = ":m '>+1<CR>gv-gv",
		},
		description = "Move line/block down",
	},
	{
		"<M-k>",
		{
			n = ":m .-2<CR>==",
			i = "<Esc>:m .-2<CR>==gi",
			v = ":m '<-2<CR>gv-gv",
		},
		description = "Move line/block up",
	},
	{
		"<C-a>",
		"<Esc>_i",
		description = "Move to the start of line.",
		mode = "i",
	},
	{
		"<C-e>",
		"<Esc>g_a",
		description = "Move to the end of line.",
		mode = "i",
	},
}

local mapping_groups = { core, clipboard, window, movement }

for _, group in pairs(mapping_groups) do
	kmaps(group)
end
