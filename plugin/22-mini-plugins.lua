Pack.add({
  "nvim-mini/mini.nvim",
  data = {
    config = function ()
      -- Mini.ai
      local ai = require("mini.ai")
      local opts = {
        n_lines = 500,
        mappings = {
          around_next = "aN",
          inside_next = "iN",
          around_last = "aL",
          inside_last = "iL",
        },
        custom_textobjects = {
          -- digit/numbers
          d = { "%f[%d]%d+" },
          -- subword
          e = function (ai_type, id, _)
            local SEP = "_%-"
            if ai_type == "a" then
              return {
                {
                  -- pattern, [^_]pattern__
                  "%f[%a" .. SEP .. "]%l+%d*[" .. SEP .. "]*",
                  "%f[%w" .. SEP .. "]%d+[" .. SEP .. "]*",
                  "%f[%u" .. SEP .. "]%u%f[%A]%d*[" .. SEP .. "]*",
                  "%f[%u" .. SEP .. "]%u%l+%d*[" .. SEP .. "]*",
                  "%f[%u" .. SEP .. "]%u%u+%d*[" .. SEP .. "]*",
                  --__pattern
                  "%f[" .. SEP .. "][" .. SEP .. "]+%l+%d*",
                  "%f[" .. SEP .. "][" .. SEP .. "]+%d+",
                  "%f[" .. SEP .. "][" .. SEP .. "]+%u%f[%A]%d*",
                  "%f[" .. SEP .. "][" .. SEP .. "]+%u%l+%d*",
                  "%f[" .. SEP .. "][" .. SEP .. "]+%u%u+%d*",
                  --[_]pattern__[%s]
                  "%f[^" .. SEP .. "]%l+%d*[" .. SEP .. "]+%f[%s]",
                  "%f[^" .. SEP .. "]%d+[" .. SEP .. "]+%f[%s]",
                  "%f[^" .. SEP .. "]%u%f[%A]%d*[" .. SEP .. "]+%f[%s]",
                  "%f[^" .. SEP .. "]%u%l+%d*[" .. SEP .. "]+%f[%s]",
                  "%f[^" .. SEP .. "]%u%u+%d*[" .. SEP .. "]+%f[%s]",
                },
                "^().*()$",
              }
            end
            if ai_type == "i" then
              local reg = ai.find_textobject("a", id, opts)
              if reg then
                local line = vim.fn.getline(reg.from.line)
                local _, s = line:find("^[" .. SEP .. "]*.", reg.from.col)
                local e = line:sub(1, reg.to.col):find(".[" .. SEP .. "]*$")
                return vim.tbl_deep_extend("force", reg, {
                  from = { col = s },
                  to = { col = e },
                })
              end
            end
          end,
          --function
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          -- if statements/for loops
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          -- Class declerations
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          -- HTML Tags
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
      ai.setup(opts)

      -- mini.completion
      local comp_opts = {
        lsp_completion = {
          source_func = "omnifunc",
          auto_setup = false,
          process_items = function (items, base)
            for _, item in ipairs(items) do
              item.detail = nil
              item.labelDetails = nil
            end
            if _G.vimsnip then
              vim.list_extend(items, _G.vimsnip.get_items(base))
            end
            local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
            return _G["MiniCompletion"].default_process_items(items, base, process_items_opts)
          end,
        },
      }
      require("mini.completion").setup(comp_opts)

      -- mini.diff
      require("mini.diff").setup({})

      -- mini.icons
      local icons = require("mini.icons")
      local style = vim.g.use_nerdfonts and "glyph" or "ascii"
      icons.setup({ style = style })

      -- mini.indentscope
      local ind_opts = { symbol = vim.g.iconchars.misc.v_border }
      require("mini.indentscope").setup(ind_opts)

      -- mini.input
      local key_handler = function (state, key)
        state.opts.prompt = state.opts.prompt:gsub("[?:]%s*$", "")
        if state.opts.prompt == "Editor action" then
          state.opts.scope = "editor"
        end
        if state.opts.prompt:find("[Pp]assword") ~= nil then
          state.opts.hide = true
        end
        state = _G.MiniInput.default_key(state, key) or state
        if state.input == "AF" then
          state.input, state.status = "Autofilled input", "accept"
        end
      end
      require("mini.input").setup({ handlers = { key = key_handler } })
      local cmdline_opts = { prompt = "Command", scope = "editor" }
      local highlight_vim = _G.MiniInput.gen_highlight.treesitter("vim")
      local highlight_cmdline = function (state)
        state = highlight_vim(state) or state
        return _G.MiniInput.default_highlight(state) or state
      end
      cmdline_opts.handlers = { highlight = highlight_cmdline }
      cmdline_opts.completion = "cmdline"
      _G.MiniInput.cmdline = function ()
        local cmd = _G.MiniInput.get(cmdline_opts)
        if cmd ~= nil then vim.cmd(cmd) end
      end

      -- mini.keymap
      local key = require("mini.keymap")
      -- Better Escape
      local escape_modes = { "i", "c", "x", "s" }
      key.map_combo(escape_modes, "jk", "<BS><BS><Esc>")
      key.map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
      -- Smart Tab
      local tab_modes = { "i", "s" }
      local tab_steps = {
        "vimsnippet_next", "pmenu_next", "increase_indent", "jump_after_tsnode", "jump_after_close",
      }
      local shifttab_steps = {
        "vimsnippet_prev", "pmenu_prev", "decrease_indent", "jump_before_tsnode", "jump_before_open",
      }
      key.map_multistep(tab_modes, "<Tab>", tab_steps)
      key.map_multistep(tab_modes, "<S-Tab>", shifttab_steps)
      -- Cursor Movement
      local cursor_modes = { "n", "x" }
      key.map_combo(cursor_modes, "ll", "g$")
      key.map_combo(cursor_modes, "hh", "g^")
      key.map_combo(cursor_modes, "jj", "}")
      key.map_combo(cursor_modes, "kk", "{")
      -- mini.pairs compat
      key.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
      key.map_multistep("i", "<BS>", { "minipairs_bs" })
      -- Edit last spellcheck error
      key.map_combo("i", "hh", "<BS><BS><Esc>[s1z=gi<Right>")
      -- Clear search highlights
      key.map_combo(cursor_modes, "<Esc><Esc>", function ()
        vim.cmd("nohlsearch")
      end)

      -- mini.move
      local mv_opts = { options = { reindent_linewise = true } }
      require("mini.move").setup(mv_opts)

      -- mini.pairs
      require("mini.pairs").setup({})

      -- mini.sessions
      require("mini.sessions").setup({})

      -- mini.surround
      local surr_opts = {
        custom_surroundings = {
          ["("] = { output = { left = "( ", right = " )" } },
          ["["] = { output = { left = "[ ", right = " ]" } },
          ["{"] = { output = { left = "{ ", right = " }" } },
          ["<"] = { output = { left = "< ", right = " >" } },
        },
        mappings = {
          add = "ys",
          delete = "ds",
          find = "",
          find_left = "",
          highlight = "",
          replace = "cs",
          update_n_lines = "",
        },
        search_method = "cover_or_next",
      }
      require("mini.surround").setup(surr_opts)
    end,
    keys = {
      -- mini.diff
      {
        [[\d]],
        "<Cmd>lua _G.MiniDiff.toggle_overlay()<CR>",
        desc = "Toggle hunk view",
      },
      -- mini.indentscope
      {
        "S",
        function ()
          if not vim.list_contains({ "d", "c", "y", "g@" }, vim.v.operator) then
            return
          end
          if vim.v.operator == "g@" and not vim.o.operatorfunc:find("vim._comment") then
            return
          end
          local scope = _G.MiniIndentscope.get_scope(nil, math.huge)
          for _ = 2, vim.v.count1 do
            scope = _G.MiniIndentscope.get_scope(scope.border.top, math.huge)
          end
          if scope.border.indent < 0 then
            return
          end
          local change = function (from, to, with)
            vim.api.nvim_buf_set_lines(0, from - 1, to, false, with)
          end
          local dedent = function (from, to)
            vim.cmd(string.format("silent %s,%s <", from, to))
          end
          local cursor = vim.api.nvim_win_get_cursor(0)
          local select = function (from, to)
            if from == false then
              vim.api.nvim_win_set_cursor(0, cursor)
              return
            end
            vim.api.nvim_win_set_cursor(0, { from, 0 })
            vim.cmd([[norm! V]])
            vim.api.nvim_win_set_cursor(0, { to, 0 })
          end
          local border, body = scope.border, scope.body
          local inner_lines = vim.api.nvim_buf_get_lines(0, body.top - 1, body.bottom, false)
          if vim.v.operator == "g@" then
            require("vim._comment").toggle_lines(border.top, body.top - 1)
            require("vim._comment").toggle_lines(body.bottom + 1, border.bottom)
            return
          end
          if vim.list_contains({ "y", "d", "c" }, vim.v.operator) then
            local copy = {}
            vim.list_extend(
              copy, vim.api.nvim_buf_get_lines(0, border.top - 1, body.top - 1, false)
            )
            vim.list_extend(copy, vim.api.nvim_buf_get_lines(0, body.bottom, border.bottom, false))
            -- NOTE: `setreg` doesn't work inside `vim.keymap.set("o")`
            vim.schedule(function ()
              vim.fn.setreg(vim.v.register, table.concat(copy, "\n"), "l")
            end)
          end
          if vim.v.operator == "y" then
            return
          end
          if vim.v.operator == "d" then
            change(border.top, border.bottom, inner_lines)
            dedent(border.top, border.top + #inner_lines - 1)
            select(false)
            -- HACK: defer cursor to avoid visual selection
            vim.schedule(function ()
              _G.MiniIndentscope.move_cursor("top", true, scope)
            end)
          end
          if vim.v.operator == "c" then
            table.insert(inner_lines, 1, "")
            change(border.top, border.bottom, inner_lines)
            dedent(border.top + 1, border.top + #inner_lines - 1)
            select(border.top, body.top - 1)
          end
        end,
        mode = "o",
        desc = "Border scope textobject",
      },
      -- mini.input
      {
        ":",
        "<Cmd>lua _G.MiniInput.cmdline()<CR>",
      },
      -- mini.sessions
      {
        "<Leader>ss",
        "<Cmd>lua MiniSessions.select()<CR>",
        desc = "Select an available session",
      },
      {
        "<Leader>sd",
        "<Cmd>lua MiniSessions.select('delete')<CR>",
        desc = "Delete an available session",
      },
      {
        "<Leader>sw",
        function ()
          local sessions = require("mini.sessions")
          vim.ui.input({ prompt = "Enter name for session: " }, function (input)
            sessions.write(input)
          end)
        end,
        desc = "Save current workspace as new/existing session",
      },
      -- mini.surround
      {
        "s",
        "<Cmd><C-u>lua MiniSurround.add('visual')<CR>",
        mode = "x",
        desc = "Add surroundinf to selection",
      },
    },
  },
})
