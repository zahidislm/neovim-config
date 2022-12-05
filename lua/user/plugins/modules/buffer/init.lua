-- ------------------------- Buffer, Statusline ------------------------- --
use({
    "feline-nvim/feline.nvim",
    requires = {
        { "nvim-tree/nvim-web-devicons" },
        {
            "lewis6991/gitsigns.nvim",
            config = 'require(P_CONFIGS .. "buffer.gitsigns")',
            event = "BufReadPre",
        },
    },
    config = 'require(P_CONFIGS .. "buffer.feline")',
})
