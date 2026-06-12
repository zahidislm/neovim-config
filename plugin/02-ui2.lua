if vim.g.loaded_ui2 then
  return
end

vim.g.loaded_ui2 = true

require("vim._core.ui2").enable({
  enable = true,
  msg = { target = "msg" },
})
