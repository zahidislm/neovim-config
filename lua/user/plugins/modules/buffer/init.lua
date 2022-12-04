-- ------------------------- Buffer, Statusline ------------------------- --
use({
    "feline-nvim/feline.nvim",
    requires = {
        {"nvim-tree/nvim-web-devicons"},
        {
            "lewis6991/gitsigns.nvim",
            config = 'require(P_CONFIGS .. "buffer.gitsigns")'
        }
    },
    config = 'require(P_CONFIGS .. "buffer.feline")'
})

use({
  "ghillb/cybu.nvim",
  branch = "main",
  requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
  setup = 'require(P_MAPPINGS .. "buffer.cybu")',
  config = 'require(P_CONFIGS .. "buffer.cybu")',
})
