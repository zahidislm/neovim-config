-- Start-up Screen
vim.pack.add({ "https://github.com/nvim-mini/mini.starter" })
if vim.fn.argc() == 0 then
  local starter = require("mini.starter")
  starter.setup({
    items = {
      function ()
        if _G.MiniSessions == nil then return {} end
        return starter.sections.sessions(5, true)()
      end,
      starter.sections.recent_files(5, true, false),
      starter.sections.builtin_actions(),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.aligning("center", "center"),
    },
  })
end

-- Custom Icon Handler
require("ui.icons")

-- UI Elements
vim.api.nvim_create_autocmd("BufEnter", {
  once = true,
  callback = function ()
    require("ui.statuscolumn").setup()
    vim.o.quickfixtextfunc = "{ item -> v:lua.require('ui.quickfix').text(item) }"
  end,
})
