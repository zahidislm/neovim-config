local api, fn = vim.api, vim.fn
local aucmd = api.nvim_create_autocmd

-- create_augroup wrapper
local function augroup(name, func)
  func(api.nvim_create_augroup(name, { clear = true }))
end

augroup("ActiveWinCursorLine", function (g)
  -- Highlight current line only on focused window
  aucmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = g,
    command = "if ! &cursorline && ! &pvw | setlocal cursorline | endif",
  })

  aucmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
    group = g,
    command = "if &cursorline && ! &pvw | setlocal nocursorline | endif",
  })
end)

augroup("AutoCreateDir", function (g)
  aucmd({ "BufWritePre", "FileWritePre" }, {
    group = g,
    callback = function (event)
      local file = vim.uv.fs_realpath(event.match) or event.match
      fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
      local backup = fn.fnamemodify(file, ":p:~:h")
      backup = backup:gsub("[/\\]", "%%")
      vim.go.backupext = backup
    end,
    desc = "Create directories when needed, when saving a file.",
  })
end)

augroup("AutoResizeWindows", function (g)
  aucmd({ "VimResized" }, {
    group = g,
    callback = function ()
      local current_tab = fn.tabpagenr()
      vim.cmd([[tabdo wincmd =]])
      vim.cmd([[tabnext ]] .. current_tab)
    end,
    desc = "Resize splits if window resized.",
  })
end)

augroup("BufLastLocation", function (g)
  aucmd({ "BufReadPost" }, {
    group = g,
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"zz" | endif]],
    desc = "Restore cursor position to last known position on read.",
  })
end)

augroup("CloseWithQ", function (g)
  aucmd({ "FileType" }, {
    group = g,
    callback = function (event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
    end,
    desc = "Close some filetypes with <q>.",
    pattern = {
      "qf",
      "help",
      "man",
      "notify",
      "nvim-pack",
      "lspinfo",
      "startuptime",
      "checkhealth",
    },
  })
end)

augroup("CustomQFSyntax", function (g)
  aucmd({ "FileType" }, {
    group = g,
    pattern = "qf",
    callback = function ()
      -- Use a custom guard to avoid conflicts with Neovim's default qf syntax
      if vim.b.qf_custom_syntax_loaded then
        return
      end

      -- Clear default quickfix syntax to prevent rule conflicts
      vim.cmd([[syntax clear]])

      vim.cmd(
        [[
      syntax match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
      syntax match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
      syntax match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
      syntax match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote

      highlight default link qfFileName Directory
      highlight default link qfSeparatorLeft Delimiter
      highlight default link qfSeparatorRight Delimiter
      highlight default link qfLineNr LineNr
      ]]
      )

      vim.b.qf_custom_syntax_loaded = true
    end,
  })
end)

augroup("DiagnosticListUpdate", function (g)
  aucmd({ "DiagnosticChanged" }, {
    group = g,
    callback = function (args)
      local qf = fn.getqflist({ title = true, winid = true })
      if qf.winid ~= 0 and qf.title == "Diagnostics" then
        vim.diagnostic.setqflist({ open = false })
      end

      for _, win in ipairs(fn.win_findbuf(args.buf) or {}) do
        local loc = fn.getloclist(win, { title = true, winid = true })
        if loc.winid ~= 0 and loc.title == "Diagnostics" then
          vim.diagnostic.setloclist({ win_id = win, open = false })
        end
      end
    end,
    desc = "Update open diagnostic quickfix and location lists",
  })
end)

augroup("DisableAutoComment", function (g)
  aucmd({ "FileType" }, {
    group = g,
    callback = function (args)
      vim.b[args.buf].minicompletion_disable = true
    end,
    desc = "Disable auto-completion on incompatible filetypes",
    pattern = { "artio-picker" },
  })
end)

augroup("DisableIndentLine", function (g)
  aucmd({ "FileType" }, {
    group = g,
    callback = function (args)
      vim.b[args.buf].miniindentscope_disable = true
    end,
    desc = "Disable mini.indentscope on incompatible filetypes",
    pattern = vim.g.md_filetypes,
  })
end)

augroup("DisableCompletion", function (g)
  aucmd("BufWinEnter", {
    group = g,
    callback = function ()
      vim.cmd("set formatoptions-=cro")
    end,
    desc = "Disable auto-commenting on newline.",
  })
end)

augroup("FileHotReload", function (g)
  aucmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = g,
    callback = function ()
      local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
      local mode = api.nvim_get_mode()["mode"]
      if (not regex:match_str(mode)) and fn.getcmdwintype() == "" then
        vim.cmd([[checktime]])
      end
    end,
    desc = "Reload file from disk if file has been modified/changed.",
  })

  aucmd({ "FileChangedShellPost" }, {
    group = g,
    callback = function ()
      vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
    end,
    desc = "Notify if file has changed outside current session and buffer reloaded.",
  })
end)

augroup("FloatDocs", function (g)
  aucmd({ "BufWinEnter" }, {
    group = g,
    callback = function (args)
      local ft = vim.bo[args.buf].filetype
      if ft ~= "help" and ft ~= "man" then
        return
      end

      local win = api.nvim_get_current_win()
      local config = api.nvim_win_get_config(win)

      if config.relative ~= "" then
        return
      end

      local width = math.floor(vim.o.columns * 0.65)
      local height = math.floor(vim.o.lines * 0.65)
      local col = math.floor((vim.o.columns - width) / 2)
      local row = math.floor((vim.o.lines - height) / 2)

      local title_text = ft == "help" and " Vimdoc " or " Man Page "

      api.nvim_win_set_config(win, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title_text,
        title_pos = "center",
      })
    end,
  })
end)

augroup("HighlightOnYank", function (g)
  aucmd({ "TextYankPost" }, {
    group = g,
    callback = function ()
      vim.highlight.on_yank()
    end,
    desc = "Create directories when needed, when saving a file.",
  })
end)

augroup("SmartScrolloff", function (g)
  aucmd("WinResized", {
    group = g,
    callback = function ()
      local scrolloffPercentage = 0.2
      vim.opt.scrolloff = math.floor(vim.o.lines * scrolloffPercentage)
    end,
    desc = "Updates scrolloff on startup and when window is resized.",
  })
end)
