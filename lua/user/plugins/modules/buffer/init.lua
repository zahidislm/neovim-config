-- ------------------------- Buffer, Statusline ------------------------- --
use({
    "nvim-lualine/lualine.nvim",
    requires = {
        {"kyazdani42/nvim-web-devicons"},
        {
            "lewis6991/gitsigns.nvim",
            config = 'require(P_CONFIGS .. "buffer.gitsigns")'
        }
    },
    config = 'require(P_CONFIGS .. "buffer.lualine")'
})

use({
    "akinsho/bufferline.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = 'require(P_CONFIGS .. "buffer.bufferline")'
})
