vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = require("ui.lsp-hover").__generate_highlights,
})

if vim.v.vim_did_enter == 1 then
  require("ui.lsp-hover").__generate_highlights()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = require("ui.lsp-hover").__generate_highlights,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/hover") then
      return
    end

    local hover = require("ui.lsp-hover")
    vim.keymap.set("n", hover.config.keymap, hover.open, {
      buffer = args.buf,
      desc = "LSP hover (dynamic float)",
    })
  end,
})
