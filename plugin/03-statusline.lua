-- CORE EVENTS
local core_group = vim.api.nvim_create_augroup("StatuslineEvents", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme", "VimResume", "UIEnter" }, {
  group = core_group,
  callback = function ()
    require("ui.statusline.highlight").on_colorscheme()
  end,
  desc = "[statusline] restore highlights and redraw",
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = core_group,
  callback = function (ev)
    require("ui.statusline.cache").clear_win(tonumber(ev.match))
  end,
  desc = "[statusline] cleanup window state",
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = core_group,
  callback = function (args)
    require("ui.statusline.cache").clear_buf(args.buf)
  end,
  desc = "[statusline] clear git timer for closed buffer",
})

vim.api.nvim_create_autocmd("DirChanged", {
  group = core_group,
  callback = function ()
    require("ui.statusline.providers.git_daemon").stop_watchers()
    require("ui.statusline.cache").clear_session()
  end,
  desc = "[statusline] clear global git cache",
})

-- THE LAZY BOOTLOADER (Only responsible for booting the render engine)
local lazy_group = vim.api.nvim_create_augroup("StatuslineLazyLoad", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  group = lazy_group,
  callback = function ()
    require("ui.statusline").init(core_group)
  end,
  desc = "Lazy load statusline render engine",
})
