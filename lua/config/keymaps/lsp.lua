local M = {}

-- Keymap helper
local function keymap(mode, lhs, rhs, bufnr, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
end

function M.global_provider(bufnr)
  keymap(
    "n", "gri", "<Cmd>Glance implementations<CR>", bufnr, "Show implementations of the cursorword"
  )

  keymap("n", "grr", "<Cmd>Glance references<CR>", bufnr, "Show references of the cursorword")

  keymap(
    "n", "grt", "<Cmd>Glance type_definitions<CR>", bufnr, "Show type definitions of the cursorword"
  )

  keymap("n", "grO", "<Cmd>Glance definitions<CR>", bufnr, "Show definition of the cursorword")
end

function M.rename_provider(client, bufnr)
  local caps = client ~= nil and client.server_capabilities or {}

  if caps.renameProvider then
    keymap("n", "grN", function ()
      require("live-rename").rename({ text = "", insert = true })
    end, bufnr, "change LSP symbol"
    )

    keymap("n", "grn", function ()
      require("live-rename").rename()
    end, bufnr, "edit LSP symbol"
    )
  end
end

function M.format_provider(client, bufnr)
  local caps = client ~= nil and client.server_capabilities or {}

  if caps.documentFormattingProvider then
    local modes = caps.documentRangeFormattingProvider and { "n", "v" } or { "n" }
    keymap(modes, "grf", function ()
      vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
      if vim.fn.exists(":GuessIndent") then vim.cmd("silent GuessIndent") end
    end, bufnr, "format code"
    )
  end
end

return M
