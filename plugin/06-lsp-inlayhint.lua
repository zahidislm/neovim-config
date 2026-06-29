vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("EnableLspInlayHint", { clear = true }),
  callback = function (args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil then
      if client:supports_method("textDocument/inlayHint") then
        local inlay_hints_group = vim.api.nvim_create_augroup("toggle_inlay_hints", {
          clear = false,
        })

        -- Initial inlay hint display.
        -- Idk why but without the delay inlay hints aren't displayed at the very start.
        vim.defer_fn(function ()
          local mode = vim.api.nvim_get_mode().mode
          vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
        end, 200)

        vim.api.nvim_create_autocmd("InsertEnter", {
          group = inlay_hints_group,
          desc = "Enable inlay hints",
          buffer = bufnr,
          callback = function ()
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end,
        })

        vim.api.nvim_create_autocmd("InsertLeave", {
          group = inlay_hints_group,
          desc = "Disable inlay hints",
          buffer = bufnr,
          callback = function ()
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
        })
      end
    end
  end,
})
