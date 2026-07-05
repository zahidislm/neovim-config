local function schedule_highlight_gen()
  vim.defer_fn(require("ui.hovers.diagnostics").__generate_highlights, 20)
  vim.defer_fn(require("ui.hovers.lsp").__generate_highlights, 20)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = schedule_highlight_gen,
})

if vim.v.vim_did_enter == 1 then
  schedule_highlight_gen()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = schedule_highlight_gen,
  })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function ()
    if _G.diaghover.window and vim.api.nvim_get_current_win() ~= _G.diaghover.window then
      _G.diaghover.close()
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/hover") then
      return
    end

    local hover = require("ui.hovers.lsp")
    vim.keymap.set("n", hover.config.keymap, hover.open, {
      buffer = args.buf,
      desc = "LSP hover (dynamic float)",
    })
  end,
})
