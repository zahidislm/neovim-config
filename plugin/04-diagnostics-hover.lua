vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback =  require("ui.diag-hover").__generate_highlights,
})

if vim.v.vim_did_enter == 1 then
  require("ui.diag-hover").__generate_highlights()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback =  require("ui.diag-hover").__generate_highlights,
  })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function ()
    if _G.diaghover.window and vim.api.nvim_get_current_win() ~= _G.diaghover.window then
      _G.diaghover.close()
    end
  end,
})
