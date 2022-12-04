-- Treesitter parsers
PARSERS = {
    "c", "cpp", "json", "lua", "python", "rust",
    "toml", "yaml",
}

-- LSP
SERVERS = {
    "pyright", "lua-language-server", "clangd",
    "typescript-language-server",
}

FORMATTERS = { "black", "rustfmt", "stylua", "clang-format" }

-- Plugin Manager
PLUGINS = { "packer" }

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
PACKER_PATH = vim.fn.stdpath("data") .. "\\site\\pack\\packer"
P_CONFIGS = "user.plugins.configs."
P_MAPPINGS = "user.plugins.mappings."
P_MODULES = "user.plugins.modules."

-- Linting icons
ICON_ERROR = "E"
ICON_WARN = "W"
ICON_INFO = "I"
ICON_HINT = "H"

-- Improve startuptime using impatient
require(P_CONFIGS .. "startup.impatient")

-- Configuration files
require("user.core.autocmds")
require("user.core.options")
require("user.core.utils")
require("user.core.keymaps")
require("user.plugins")
require("user.core.keymaps")
require("user.plugins")
