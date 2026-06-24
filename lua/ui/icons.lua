vim.g.iconchars = {
  diagnostics = {
    Error = "⛒ ",
    Warn = "⚠ ",
    Info = "Ⓘ ",
    Hint = "Ⓗ ",
  },
  git = {
    LineAdded = "⊕",
    LineModified = "⊙",
    LineRemoved = "⊖",
    FileModified = "⊙",
    FileDeleted = "⊖",
    FileIgnored = "◌",
    FileRenamed = "↻",
    FileStaged = "✓",
    FileUnmerged = "x",
    FileUnstaged = "x",
    FileUntracked = "？",
    Diff = "⤭",
    Repo = "",
    Octoface = "",
    Branch = "⑆",
  },
  statusline = {
    separators = { left = "█", right = "█" },
    session = "",
    lines = "▤ ",
    label = "☆",
  },
  misc = {
    collapsed = ">",
    expanded = "v",
    condense = "⇞ ",
    h_border = "─",
    v_border = "│ ",
    prompt = "⌕ ",
    next_line = "↩ ",
    textured_box = "▨ ",
    pad_line = "▌",
  },
}

-- Nerdcon Support
vim.g.nerdchars = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = " ",
  },
  git = {
    LineAdded = "",
    LineModified = "",
    LineRemoved = "",
    FileModified = "",
    FileDeleted = "",
    FileIgnored = "◌",
    FileRenamed = "",
    FileStaged = "",
    FileUnmerged = "",
    FileUnstaged = "",
    FileUntracked = "",
    Diff = "",
    Repo = "",
    Octoface = "",
    Branch = "󰘬",
  },
  misc = {
    collapsed = "󰅂",
    expanded = "󰅀",
    prompt = "  ",
    textured_box = "󰿦 ",
  },
  statusline = {
    separators = { left = "", right = "" },
    session = " ",
    lines = "󱪶 ",
    label = "󰃃",
  },
}

if vim.g.use_nerdfonts then
  vim.g.iconchars = vim.tbl_deep_extend("force", vim.g.iconchars, vim.g.nerdchars)
end
