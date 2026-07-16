-- MD files
vim.g.loaded_render_markdown = true
Pack.add({
  "MeanderingProgrammer/render-markdown.nvim",
  data = {
    config = function ()
      local opts = {
        file_types = vim.g.md_filetypes,
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.g.md_filetypes,
        once = true,
        callback = function ()
          require("render-markdown").setup(opts)
          require("render-markdown.core.colors").init()
          require("render-markdown.core.manager").init()
        end,
      })
    end,
  },
})

-- vim-slime
if vim.fn.has("mac") == 1 and vim.env.TERM_PROGRAM == "ghostty" then
  Pack.add({
    "rkube/ghostty-slime.nvim",
    data = { main = "ghostty_slime", config = {} },
  })
else
  Pack.add({
    "jpalardy/vim-slime",
    init = function ()
      vim.b['quarto_is_python_chunk'] = false
      vim.g.slime_dispatch_ipython_pause = 100
      function _G.SlimeOverride_EscapeText_quarto(text)
        local has_ipython = vim.g.slime_python_ipython ~= nil
        local is_multiline = text:find("\n") ~= nil
        local is_py_chunk = vim.b.quarto_is_python_chunk == 1
          or vim.b.quarto_is_python_chunk == true
        local is_r_mode = vim.b.quarto_is_r_mode == 1 or vim.b.quarto_is_r_mode == true

        if has_ipython and is_multiline and is_py_chunk and not is_r_mode then
          return { "%cpaste -q\n", vim.g.slime_dispatch_ipython_pause, text, "--", "\n" }
        elseif is_r_mode and is_py_chunk then
          return { text, "\n" }
        else
          return { text }
        end
      end

      vim.cmd([[
      function! SlimeOverride_EscapeText_quarto(text)
      return v:lua.SlimeOverride_EscapeText_quarto(a:text)
      endfunction
      ]])

      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true
      vim.g.slime_cell_delimiter = "#%%"
    end,
    keys = {
      { "<Leader>rc", "<Plug>SlimeSendCell", desc = "Run cell" },
      { "<Leader>rF", ":%SlimeSend<CR>", desc = "Run entire file" },
      { "<Leader>rl", "<Plug>SlimeLineSend", desc = "Run line" },
      { "<Leader>rs", "<Plug>SlimeMotionSend", desc = "Run textobject" },
      { "<Leader>rs", "<Plug>SlimeRegionSend", mode = "x", desc = "Run visual selection" },
    },
  })
end
