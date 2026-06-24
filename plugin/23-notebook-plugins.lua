-- Jupyter Kernel Notebooks
Pack.add({
  "sheng-tse/jupynvim",
  data = {
    build = function (path)
      local install = loadfile(path .. "/lua/jupynvim/install.lua")()
      install.run({ dir = path })
    end,
    config = { explorer_keys = {}, terminal_keys = {}, pick_keys = {} },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.g.md_filetypes,
  once = true,
  callback = function ()
    vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

    local opts = {
      completions = { lsp = { enabled = true } },
      heading = {
        sign = false,
        border = true,
        width = "block",
        below = "▔",
        above = "▁",
        left_pad = 0,
        right_pad = 4,
        position = "left",
        icons = {
          "█ ",
          "██ ",
          "███ ",
          "████ ",
          "█████ ",
          "██████ ",
        },
      },
      code = {
        sign = false,
        border = "thin",
        position = "right",
        width = "block",
        above = "▁",
        below = "▔",
        language_left = "█",
        language_right = "█",
        language_border = "▁",
        left_pad = 1,
        right_pad = 1,
      },
    }

    require("render-markdown").setup(opts)
  end,
})
