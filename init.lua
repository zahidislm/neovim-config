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
SERVERS = {
	"pyright",
	"rust_analyzer",
	"sumneko_lua",
	"taplo",
}

FORMATTERS = { "black", "rustfmt", "stylua", "taplo" }

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
DATA_PATH = vim.fn.stdpath("data")

-- Configuration files
require("core")
require("lazy-manager")
