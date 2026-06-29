local function toggle_qf()
  local qf_exists = vim.fn.getqflist({ winid = 0 }).winid ~= 0
  if qf_exists then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

local function toggle_loc()
  local loc_exists = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
  if loc_exists then
    vim.cmd.lclose()
  else
    if #vim.fn.getloclist(0) > 0 then
      vim.cmd.lopen()
    else
      vim.notify("Location list is currently empty.", vim.log.levels.WARN)
    end
  end
end

local function toggle_spell()
  vim.wo.spell = not vim.wo.spell
  if vim.wo.spell then
    vim.bo.spelllang = "en_us"
    vim.notify("spellcheck: ON (en_us)", vim.log.levels.INFO)
  else
    vim.notify("spellcheck: OFF", vim.log.levels.INFO)
  end
end

-- Keymap helper
local function keymap(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

local function toggle_keymap(lhs, rhs, desc)
  local prefix = [[\]]
  keymap("n", prefix .. lhs, rhs, { desc = desc })
end

toggle_keymap("c", "<Cmd>setlocal cursorline!<CR>", "toggle 'cursorline'")
toggle_keymap("C", "<Cmd>setlocal cursorcolumn!<CR>", "toggle 'cursorcolumn'")
toggle_keymap("n", "<Cmd>setlocal number!<CR>", "toggle 'number'")
toggle_keymap("l", toggle_loc, "toggle loclist")
toggle_keymap("q", toggle_qf, "toggle quickfix list")
toggle_keymap("r", "<Cmd>setlocal relativenumber!<CR>", "toggle 'relativenumber'")
toggle_keymap("s", toggle_spell, "toggle 'spell'")
toggle_keymap("w", "<Cmd>setlocal wrap!<CR>", "toggle 'wrap'")

toggle_keymap("d", function ()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, "toggle diagnostics"
)

toggle_keymap("H", function ()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, "toggle inlay hints"
)
