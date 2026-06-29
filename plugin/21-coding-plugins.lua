-- Codedoc Generation
Pack.add({
  "jeangiraldoo/codedocs.nvim",
  data = {
    keys = {
      {
        "gca",
        "<Cmd>Codedocs<CR>",
        desc = "Generate annotation for object under cursor",
      },
    },
  },
})

-- Cursortab
local api_key_env = "INCEPTION_AI_TOKEN"
local has_go = vim.fn.executable("go") == 1
local has_token = os.getenv(api_key_env) ~= nil
if has_go and has_token then
  Pack.add({
    "cursortab/cursortab.nvim",
    data = {
      build = "cd server && go build",
      config = {
        provider = {
          type = "mercuryapi",
          api_key_env = api_key_env,
        },
        keymaps = { partial_accept = false },
        behavior = { text_change_debounce = 270 },
        debug = { immediate_shutdown = true },
      },
    },
  })
end

-- Guess Indent
Pack.add({
  "nmac427/guess-indent.nvim",
  data = {
    config = { filetype_exclude = { "netrw", "tutor", "ministarter", "artio-picker" } },
  },
})

-- Live Rename
Pack.add("saecki/live-rename.nvim")

-- Treesitter Parsers
Pack.add({
  "romus204/tree-sitter-manager.nvim",
  data = {
    config = { ensure_installed = vim.g.enabled_syntax_languages },
  },
})

-- Treesitter Text Objects
Pack.add({
  "nvim-treesitter/nvim-treesitter-textobjects",
  version = "main",
  data = {
    keys = {
      {
        "]a",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_next_start("@parameter.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to next param",
      },
      {
        "]c",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_next_start("@code_cell.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to next Code Cell",
      },
      {
        "]f",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to next Func/Method",
      },
      {
        "]]",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to next Class object",
      },
      {
        "]z",
        function ()
          require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to next fold",
      },
      {
        "[a",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_previous_start("@parameter.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to previous param",
      },
      {
        "[c",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_previous_start("@code_cell.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to previous Code Cell",
      },
      {
        "[f",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to previous Func/Method",
      },
      {
        "[[",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to previous Class object",
      },
      {
        "[z",
        function ()
          require("nvim-treesitter-textobjects.move")
            .goto_previous_start("@fold", "folds")
        end,
        mode = { "n", "x", "o" },
        desc = "Move to previous fold",
      },
      {
        ">A",
        function ()
          require("nvim-treesitter-textobjects.swap")
            .swap_next("@parameter.inner")
        end,
        desc = "Swap next argument",
      },
      {
        "<A",
        function ()
          require("nvim-treesitter-textobjects.swap")
            .swap_previous("@parameter.inner")
        end,
        desc = "Swap previous argument",
      },
    },
  },
})

-- vision.nvim (editor context bridge w/ agnostic tools)
Pack.add({
  "azorng/vision.nvim",
  data = {
    config = function ()
      vim.defer_fn(function ()
        require("vision").setup({})
      end, 200)
    end,
  },
})
