local augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = augroup,
  callback = require("ui.breadcrumbs").debounced_breadcrumbs_set,
  desc = "Update winbar breadcrumbs.",
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup,
  callback = function ()
    vim.o.winbar = ""
  end,
  desc = "Clear winbar breadcrumbs on window leave.",
})

