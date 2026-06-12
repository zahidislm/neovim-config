vim.api.nvim_create_autocmd("BufReadPre", {
  once = true,
  callback = function ()
    local opts = {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      codelens = { enabled = true },
      signs = { text = {}, hl = {}, numhl = {} },
    }

    -- add icons to diagnostics
    if vim.g.iconchars and vim.g.iconchars.diagnostics then
      for type, _ in pairs(vim.g.iconchars.diagnostics) do
        local hl = "DiagnosticSign" .. type
        local severity = vim.diagnostic.severity[type:upper()]
        opts.signs["text"][severity] = vim.g.iconchars.misc.textured_box
        opts.signs["hl"][severity] = hl
        opts.signs["numhl"][severity] = ""
      end
    end

    vim.diagnostic.config(opts)

    -- Populates location list with diagnostics for the current buffer
    vim.keymap.set("n", "<Leader>db", vim.diagnostic.setloclist, {
      desc = "Buffer diagnostics (Loclist)",
    })

    -- Populates quickfix list with diagnostics for the entire workspace
    vim.keymap.set("n", "<Leader>dw", vim.diagnostic.setqflist, {
      desc = "Workspace diagnostics (Quickfix)",
    })
  end,
})
