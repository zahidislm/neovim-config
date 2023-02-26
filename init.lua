-- Treesitter parsers
PARSERS = {
	"bash",
	"c",
	"cpp",
	"git_rebase",
	"gitcommit",
	"html",
	"json",
	"lua",
	"python",
	"regex",
	"rust",
	"toml",
	"typescript",
	"vim",
}

-- LSP
LSP_FILETYPES = {
	"lua",
	"python",
	"rust",
	"toml",
}

SERVERS = {
	"jedi_language_server",
	"ruff_lsp",
	"rust_analyzer",
	"lua_ls",
	"taplo",
}

FORMATTERS = {
	"black",
	"rustfmt",
	"stylua",
	"taplo",
}

-- Configuration files
require("config")
require("lazy-manager")
