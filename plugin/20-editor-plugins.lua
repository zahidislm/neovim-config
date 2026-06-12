-- Artio picker
Pack.add({
  "comfysage/artio.nvim",
  data = {
    config = function ()
      require("artio").setup({
        opts = { use_icons = true },
        win = { hidestatusline = true },
      })

      vim.ui.select = require("artio").select
    end,
    keys = {
      { "<Leader>pc", "<Plug>(artio-commands)", desc = "Pick commands" },
      { "<Leader>pf", "<Plug>(artio-smart)", desc = "Pick files" },
      { "<Leader>pg", "<Plug>(artio-grep)", desc = "Pick grepped files" },
      { "<Leader>ph", "<Plug>(artio-helptags)", desc = "Pick help files" },
      { "<Leader>pq", "<Plug>(artio-quickfix)", desc = "Pick quickfix" },
      { "<Leader>pr", "<Plug>(artio-resume)", desc = "Resume last picker" },
    },
  },
})

-- Buffer Management
Pack.add({
  "serhez/bento.nvim",
  version = "feat/v2",
  data = {
    config = function ()
      local opts = { max_open_buffers = 6, locked_first = true }
      require("bento").setup(opts)

      local api = require("bento.api")

      -- Register menu keymaps
      api.register_expand_key("<CR>") -- Open/expand menu
      api.register_last_buffer_key(";") -- Label for last-accessed buffer
      api.register_collapse_key("<Esc>") -- Collapse/close menu
      api.register_prev_page_key("[") -- Previous page (pagination)
      api.register_next_page_key("]") -- Next page (pagination)

      -- Register built-in actions (using built-in action functions)
      -- with example keymaps and highlights
      api.register_action("open", {
        key = "<CR>",
        action = api.actions.open,
        hl = "DiagnosticVirtualTextHint",
      })
      api.register_action("delete", {
        key = "<BS>",
        action = api.actions.delete,
        hl = "DiagnosticVirtualTextError",
      })
      api.register_action("vsplit", {
        key = "|",
        action = api.actions.vsplit,
        hl = "DiagnosticVirtualTextInfo",
      })
      api.register_action("split", {
        key = "_",
        action = api.actions.split,
        hl = "DiagnosticVirtualTextInfo",
      })
      api.register_action("bookmark", {
        key = "m",
        action = function (buf_id, buf_name)
          api.actions.lock(buf_id, buf_name)
          vim.api.nvim_exec_autocmds("User", {
            pattern = "BookmarkChanged",
            modeline = false,
          })
        end,
        hl = "DiagnosticVirtualTextWarn",
      })

      -- Set default action
      api.set_default_action("open")
    end,
  },
})

-- Easymotion Jumping
Pack.add({
  "yorickpeterse/nvim-jump",
  data = {
    config = { label = "JumpLabel" },
    keys = {
      {
        "s",
        function ()
          require("jump").start()
        end,
        mode = { "n", "x", "o" },
        desc = "Jump",
      },
    },
  },
})

-- LSP Garbage Collector
Pack.add({
  "zahidislm/garbage-day.nvim",
  data = { config = {} },
})

-- Glance (LSP popup for Definitions, References, etc)
Pack.add({
  "dnlhc/glance.nvim",
  data = { config = { height = 15, border = { enable = true } } },
})

-- Namu (Symbol Viewer)
Pack.add({
  "bassamsdata/namu.nvim",
  data = {
    keys = { { "<Leader>ps", "<Cmd>Namu symbols<CR>", desc = "Pick symbols <Buffer>" } },
  },
})

-- Smooth Scroll
Pack.add({
  "opalmay/vim-smoothie",
  data = {
    init = function ()
      vim.g.smoothie_enabled = 1
      vim.g.smoothie_speed_exponentiation_factor = 0.6
      vim.g.smoothie_speed_constant_factor = 8
      vim.g.smoothie_update_interval = 4
    end,
  },
})

-- BQF (Better quickfix)
Pack.add({
  "kevinhwang91/nvim-bqf",
  data = {
    config = {
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        show_title = false,
        should_preview_cb = function (bufnr, _)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          end
          return ret
        end,
      },
    },
  },
})

-- Which-key
Pack.add({
  "folke/which-key.nvim",
  data = {
    config = {
      preset = "helix",
      filter = function (mapping) return mapping.desc and mapping.desc ~= "" end,
      spec = {
        { "<Leader>a", group = "assist", icon = { icon = "󰁤 ", color = "purple" } },
        { "<Leader>d", group = "diagnostic", icon = { icon = " ", color = "orange" } },
        { "<Leader>f", group = "file", icon = { icon = " " } },
        { "<Leader>n", group = "notebook", icon = { icon = " ", color = "green" } },
        { "<Leader>p", group = "pick", icon = { icon = " ", color = "yellow" } },
        { "<Leader>s", group = "session" },
        { "gr", group = "LSP" },
      },
      plugins = { spelling = { enabled = false } },
      show_help = false,
    },
  },
})
