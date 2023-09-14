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
	"markdown",
	"python",
	"regex",
	"rust",
	"svelte",
	"toml",
	"typescript",
	"vim",
}

SERVERS = {
	lua = { "lua_ls" },
	python = { "jedi_language_server", "ruff_lsp" },
	rust = { "rust_analyzer" },
	toml = { "taplo" },
}

-- node-based LSP
if vim.fn.executable("npm") == 1 then
	SERVERS["html"] = { "html", "unocss" }
	SERVERS["svelte"] = { "svelte" }
	SERVERS["javascript"] = { "rome" }
end

FORMATTERS = {
	"black",
	"stylua",
}
