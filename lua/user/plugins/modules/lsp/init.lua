-- --------------------------------- LSP & Mason -------------------------------- --
use({
    "williamboman/mason.nvim",
    config = 'require("mason").setup()'
})

use({
    "williamboman/mason-lspconfig.nvim",
    config = 'require("mason-lspconfig").setup()',
})

use({
    "neovim/nvim-lspconfig",
    config = 'require(P_CONFIGS .. "lsp.lspconfig")',
})
-- --------------------------------- NULL-LS -------------------------------- --
use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
})

use({
    "jay-babu/mason-null-ls.nvim",
    config = 'require(P_CONFIGS .. "lsp.mason.null-ls")'
})

use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = 'require(P_CONFIGS .. "lsp.mason")',
})
-- --------------------------------- LSP HINTS -------------------------------- --
use({
    "ray-x/lsp_signature.nvim",
    config = 'require(P_CONFIGS .. "lsp.signature")',
})

use({
    "glepnir/lspsaga.nvim",
    setup = 'require(P_MAPPINGS .. "lsp.lspsaga")',
    config = 'require("lspsaga").init_lsp_saga()',
})
-- --------------------------------- LSP LINT VIEWER -------------------------------- --
use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    setup = 'require(P_MAPPINGS .. "lsp.trouble")'
})
