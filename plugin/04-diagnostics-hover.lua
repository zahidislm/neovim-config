local diaghover = require("ui.diag-hover")
diaghover.setup({})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = diaghover.__generate_highlights,
})

if vim.v.vim_did_enter == 1 then
  diaghover.__generate_highlights()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = diaghover.__generate_highlights,
  })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function ()
    if diaghover.window and vim.api.nvim_get_current_win() ~= diaghover.window then
      diaghover.close()
    end
  end,
})
