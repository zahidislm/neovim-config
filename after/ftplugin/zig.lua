-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- Importing Libraries
vimsnip.add("import", 'const ${1} = @import("${1}");')

-- Importing C Header Files
vimsnip.add("cimport", 'const c = @cImport({\n\t@cDefine("${1}");\n});')
