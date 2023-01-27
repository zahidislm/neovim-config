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
	"sumneko_lua",
	"taplo",
}

FORMATTERS = {
	"black",
	"rustfmt",
	"stylua",
	"taplo",
}

-- Configuration files
require("core")
require("lazy-manager")
