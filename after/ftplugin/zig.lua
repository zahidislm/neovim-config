-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
local opt = vim.opt_local
local tabsize = 2

opt.expandtab = true
opt.shiftwidth = tabsize
opt.tabstop = tabsize
opt.softtabstop = tabsize

-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- Importing Libraries
  ["import"] = 'const ${1} = @import("${1}");',

  -- Importing C Header Files
  ["cimport"] = 'const c = @cImport({\n\t@cDefine("${1}");\n});',
})
