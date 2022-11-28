-- -------------------------------- Treesitter ------------------------------- --
use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
        { "p00f/nvim-ts-rainbow" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-context" },
    },
    config = 'require(P_CONFIGS .. "syntax.treesitter")',
})

use({
    "kyazdani42/nvim-web-devicons"
})

use({
    "lukas-reineke/indent-blankline.nvim",
    config = 'require(P_CONFIGS .. "syntax.indentline")',
})
