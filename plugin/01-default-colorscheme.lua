-- KANSO
vim.pack.add({ "https://github.com/webhooked/kanso.nvim" })
local custom_kanso = require("ui.highlights.scheme.kanso")
local kanso_opts = {
  transparent = true,
  minimal = true,
  dimInactive = true,
  overrides = custom_kanso.get_hls,
  colors = {
    theme = {
      pearl = { ui = { bg_visual = "#dfdce5" } },
    },
  },
  foreground = {
    dark = "default",
    light = "saturated",
  },
  background = {
    dark = "ink",
    light = "pearl",
  },
}

require("kanso").setup(kanso_opts)
vim.cmd([[colorscheme kanso]])
