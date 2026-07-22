local M = {}

-- ---------------------------------------------------------------------------
-- Constants
-- ---------------------------------------------------------------------------
M.skip_foldexpr = {}
local skip_check = assert(vim.uv.new_check())

-- ---------------------------------------------------------------------------
-- Utilities
-- ---------------------------------------------------------------------------
-- Custom fold logic
-- from @folke & @LazyVim team
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua#L189
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then return "0" end
  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then return "0" end
  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then return "0" end

  local ok = pcall(vim.treesitter.get_parser, buf)
  if ok then return vim.treesitter.foldexpr() end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function ()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)

  return "0"
end

-- Empties quickfix/loclist
function M.empty_lists()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]

  -- The 'r' flag replaces the current list rather than creating a new empty one
  if wininfo.loclist == 1 then
    vim.fn.setloclist(0, {}, "r")
    vim.notify("Location list emptied.", vim.log.levels.INFO)
  elseif wininfo.quickfix == 1 then
    vim.fn.setqflist({}, "r")
    vim.notify("Quickfix list emptied.", vim.log.levels.INFO)
  else
    -- If triggered from a normal buffer, safely wipe both
    vim.fn.setqflist({}, "r")
    vim.fn.setloclist(0, {}, "r")
    vim.notify("Quickfix and Location lists emptied.", vim.log.levels.INFO)
  end
end

--- Hides cursor on specific `FileType` buffers
---@param ft string
function M.smart_cursor_hidden_buffer(ft)
  local gname = ft .. "Events"
  local group = vim.api.nvim_create_augroup(gname, { clear = true })

  vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    group = group,
    callback = function (args)
      local current_ft = vim.bo.filetype

      if current_ft == ft then
        vim.opt_local.cursorline = true
        vim.b[args.buf].statusline_disable = true
        vim.b[args.buf].miniindentscope_disable = true
        vim.cmd([[hi Cursor blend=100]])
        vim.cmd([[set guicursor+=a:Cursor/lCursor]])
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    group = group,
    callback = function ()
      local current_ft = vim.bo.filetype

      if current_ft == ft then
        vim.cmd([[hi Cursor blend=0]])
      end
    end,
  })
end

return M
