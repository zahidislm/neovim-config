-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- Code snippet for if statement.
  ["if"] = "if ${1:condition}\n\t$0\nend",

  -- Code snippet for else statement.
  ["else"] = "else\n\t$0\nend",

  -- Code snippet for elseif statement.
  ["elseif"] = "elseif ${1:condition}\n\t${2:block}\nend",

  -- Code snippet for if-elseif-else statement.
  ["ifelseif"] = "if ${1:condition}\n\t${2:block}\nelseif ${3:condition}\n\t${4:block}\nelse\n\t${5:block}\nend",

  -- Code snippet for ternary operator statement.
  ["?:"] = "${1:condition} ? ${2:expression} : ${3:expression}",

  -- In the expression a && b, the subexpression b is only evaluated if a evaluates to true.
  ["&&"] = "${1:condition} && ${2:expression}",

  -- In the expression a || b, the subexpression b is only evaluated if a evaluates to false.
  ["||"] = "${1:condition} || ${2:expression}",

  -- Code snippet to create a while loop.
  ["while"] = "while ${1:condition}\n\t$0\nend",

  -- Code snippet to create a for loop.
  ["for"] = "for ${1:value}=${2:index}:${3:index}\n\t$0\nend",

  -- Code snippet to iterate each element.
  ["foreach"] = "for ${1:value} ∈ ${2:iterable}\n\t$0\nend",
  ["forin"] = "for ${1:value} ∈ ${2:iterable}\n\t$0\nend",

  -- Code snippet to iterate each element.
  ["iterate"] = "next = iterate(${1:iterable})\nwhile next !== nothing\n\t(item, state) = next\n\t0\n\tnext = iterate(iter, state)\nend",
  ["iter"] = "next = iterate(${1:iterable})\nwhile next !== nothing\n\t(item, state) = next\n\t0\n\tnext = iterate(iter, state)\nend",

  -- Code snippet to create a function.
  ["fun"] = "function ${1:name}(${2:arguments})\n\t$0\nend",
  ["func"] = "function ${1:name}(${2:arguments})\n\t$0\nend",
  ["function"] = "function ${1:name}(${2:arguments})\n\t$0\nend",

  -- Code snippet to create a begin block.
  ["be"] = "begin\n\t$0\nend",
  ["begin"] = "begin\n\t$0\nend",

  -- Code snippet to create a main block.
  ["main"] = "function main()\n\t$0\nend\n\nmain()",

  -- Code snippet for bitwise not operator.
  ["bnot"] = "~${1:value}",

  -- Code snippet for bitwise and operator.
  ["band"] = "${1:value} & ${2:value}",

  -- Code snippet for bitwise or operator.
  ["bor"] = "${1:value} | ${2:value}",

  -- Code snippet for bitwise xor (exclusive or) operator.
  ["xor"] = "${1:value} ⊻ ${2:value}",

  -- Code snippet for complex number.
  ["comp"] = "(${1:Int} + ${2:Int}im)",
  ["complex"] = "(${1:Int} + ${2:Int}im)",
  ["im"] = "(${1:Int} + ${2:Int}im)",

  -- Code snippet for parsing a String to Float64.
  ["parsef"] = 'parse(Float64, "${1:value}")',
  ["pfloat"] = 'parse(Float64, "${1:value}")',

  -- Code snippet for parsing a String to Int64.
  ["parsei"] = 'parse(Int64, "${1:value}")',
  ["pint"] = 'parse(Int64, "${1:value}")',

  -- Code snippet for map.
  ["map"] = "map(x -> ${1:expr}, ${2:iterable})",

  -- Code snippet for pipe expression.
  ["pipe"] = "${1:value} |> ${2:function}",
  ["pp"] = "${1:value} |> ${2:function}",

  -- Code snippet for pointwise pipe expression.
  ["ppipe"] = "${1:value} .|> ${2:function}",
  ["pipe."] = "${1:value} .|> ${2:function}",
  ["pp."] = "${1:value} .|> ${2:function}",

  -- Code snippet for function composition.
  ["composition"] = "(${1:fonction} ∘ ${2:fonction})(${3:args})",
  ["fcomp"] = "(${1:fonction} ∘ ${2:fonction})(${3:args})",

  -- Code snippet for module block.
  ["module"] = "module ${1:name}\nexport ${2:struct}\nstruct ${2:struct} end\n\t$0\nend",
  ["mod"] = "module ${1:name}\nexport ${2:struct}\nstruct ${2:struct} end\n\t$0\nend",

  -- Code snippet for module block.
  ["baremodule"] = "baremodule ${1:name}\n\t$0\nend",
  ["bmod"] = "baremodule ${1:name}\n\t$0\nend",
  ["bare"] = "baremodule ${1:name}\n\t$0\nend",

  -- Code snippet for struct block.
  ["struct"] = "struct ${1:struct} <: ${2:type}\n\t$0\nend",

  -- Code snippet for mutable struct block.
  ["mutable"] = "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend",
  ["mut"] = "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend",
  ["mstruct"] = "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend",

  -- Code snippet for parse an expression.
  ["meta"] = 'Meta.parse("{$1:expression}")',
  ["parse"] = 'Meta.parse("{$1:expression}")',

  -- Code snippet for using a package.
  ["using"] = "using $0",
  ["us"] = "using $0",

  -- Code snippet for import a package.
  ["import"] = "import $0",
  ["im"] = "import $0",

  -- Code snippet for using something from a package.
  ["using"] = "using ${1:package}: ${2:exports}",
  ["from"] = "using ${1:package}: ${2:exports}",
  ["us"] = "using ${1:package}: ${2:exports}",

  -- Code snippet for import something from a package.
  ["import"] = "import ${1:package}: ${2:exports}",
  ["from"] = "import ${1:package}: ${2:exports}",
  ["im"] = "import ${1:package}: ${2:exports}",

  -- Code snippet for using a package and rename.
  ["using"] = "using ${1:package} as ${2:name}",
  ["as"] = "using ${1:package} as ${2:name}",
  ["us"] = "using ${1:package} as ${2:name}",

  -- Code snippet for import a package and rename.
  ["import"] = "import ${1:package} as ${2:name}",
  ["as"] = "import ${1:package} as ${2:name}",
  ["im"] = "import ${1:package} as ${2:name}",

  -- Code snippet for using something from a package and rename.
  ["using"] = "using ${1:package}: ${2:exports} as ${3:name}",
  ["from"] = "using ${1:package}: ${2:exports} as ${3:name}",
  ["as"] = "using ${1:package}: ${2:exports} as ${3:name}",
  ["us"] = "using ${1:package}: ${2:exports} as ${3:name}",

  -- Code snippet for import something from a package and rename.
  ["import"] = "import ${1:package}: ${2:exports} as ${3:name}",
  ["from"] = "import ${1:package}: ${2:exports} as ${3:name}",
  ["as"] = "import ${1:package}: ${2:exports} as ${3:name}",
  ["im"] = "import ${1:package}: ${2:exports} as ${3:name}",

  -- An example for ccal.
  ["ccal"] = "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)",
  ["cfun"] = "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)",
  ["cfunction"] = "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)",

  -- Code snippet for calling the clock function from the standard C library.
  ["cclock"] = "ccall(:clock, Int32, ())",
  ["clock"] = "ccall(:clock, Int32, ())",
})
