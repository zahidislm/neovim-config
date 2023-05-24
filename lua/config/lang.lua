-- Treesitter parsers
PARSERS = {
	"bash",
	"c",
	"cpp",
	"git_rebase",
	"gitcommit",
	"html",
	"javascript",
	"json",
	"lua",
	"python",
	"regex",
	"rust",
	"svelte",
	"toml",
	"typescript",
	"vim",
}

SERVERS = {
	"jedi_language_server",
	"rust_analyzer",
	"ruff_lsp",
	"lua_ls",
	"taplo",
}

FORMATTERS = {
	"black",
	"rustfmt",
	"stylua",
}

-- node-based LSP
if vim.fn.executable("npm") == 1 then
	local node_lsp = { "svelte", "unocss", "vtsls" }
	SERVERS = vim.list_extend(SERVERS, node_lsp)
end
