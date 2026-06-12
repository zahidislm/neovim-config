-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- Code snippet for if statement.
vimsnip.add("if", "if ${1:condition}\n\t$0\nend")

-- Code snippet for else statement.
vimsnip.add("else", "else\n\t$0\nend")

-- Code snippet for elseif statement.
vimsnip.add("elseif", "elseif ${1:condition}\n\t${2:block}\nend")

-- Code snippet for if-elseif-else statement.
vimsnip.add(
  "ifelseif",
  "if ${1:condition}\n\t${2:block}\nelseif ${3:condition}\n\t${4:block}\nelse\n\t${5:block}\nend"
)

-- Code snippet for ternary operator statement.
vimsnip.add("?:", "${1:condition} ? ${2:expression} : ${3:expression}")

-- In the expression a && b, the subexpression b is only evaluated if a evaluates to true.
vimsnip.add("&&", "${1:condition} && ${2:expression}")

-- In the expression a || b, the subexpression b is only evaluated if a evaluates to false.
vimsnip.add("||", "${1:condition} || ${2:expression}")

-- Code snippet to create a while loop.
vimsnip.add("while", "while ${1:condition}\n\t$0\nend")

-- Code snippet to create a for loop.
vimsnip.add("for", "for ${1:value}=${2:index}:${3:index}\n\t$0\nend")

-- Code snippet to iterate each element.
vimsnip.add("foreach", "for ${1:value} ∈ ${2:iterable}\n\t$0\nend")
vimsnip.add("forin", "for ${1:value} ∈ ${2:iterable}\n\t$0\nend")

-- Code snippet to iterate each element.
vimsnip.add(
  "iterate",
  "next = iterate(${1:iterable})\nwhile next !== nothing\n\t(item, state) = next\n\t0\n\tnext = iterate(iter, state)\nend"
)
vimsnip.add(
  "iter",
  "next = iterate(${1:iterable})\nwhile next !== nothing\n\t(item, state) = next\n\t0\n\tnext = iterate(iter, state)\nend"
)

-- Code snippet to create a function.
vimsnip.add("fun", "function ${1:name}(${2:arguments})\n\t$0\nend")
vimsnip.add("func", "function ${1:name}(${2:arguments})\n\t$0\nend")
vimsnip.add("function", "function ${1:name}(${2:arguments})\n\t$0\nend")

-- Code snippet to create a begin block.
vimsnip.add("be", "begin\n\t$0\nend")
vimsnip.add("begin", "begin\n\t$0\nend")

-- Code snippet to create a main block.
vimsnip.add("main", "function main()\n\t$0\nend\n\nmain()")

-- Code snippet for bitwise not operator.
vimsnip.add("bnot", "~${1:value}")

-- Code snippet for bitwise and operator.
vimsnip.add("band", "${1:value} & ${2:value}")

-- Code snippet for bitwise or operator.
vimsnip.add("bor", "${1:value} | ${2:value}")

-- Code snippet for bitwise xor (exclusive or) operator.
vimsnip.add("xor", "${1:value} ⊻ ${2:value}")

-- Code snippet for complex number.
vimsnip.add("comp", "(${1:Int} + ${2:Int}im)")
vimsnip.add("complex", "(${1:Int} + ${2:Int}im)")
vimsnip.add("im", "(${1:Int} + ${2:Int}im)")

-- Code snippet for parsing a String to Float64.
vimsnip.add("parsef", 'parse(Float64, "${1:value}")')
vimsnip.add("pfloat", 'parse(Float64, "${1:value}")')

-- Code snippet for parsing a String to Int64.
vimsnip.add("parsei", 'parse(Int64, "${1:value}")')
vimsnip.add("pint", 'parse(Int64, "${1:value}")')

-- Code snippet for map.
vimsnip.add("map", "map(x -> ${1:expr}, ${2:iterable})")

-- Code snippet for pipe expression.
vimsnip.add("pipe", "${1:value} |> ${2:function}")
vimsnip.add("pp", "${1:value} |> ${2:function}")

-- Code snippet for pointwise pipe expression.
vimsnip.add("ppipe", "${1:value} .|> ${2:function}")
vimsnip.add("pipe.", "${1:value} .|> ${2:function}")
vimsnip.add("pp.", "${1:value} .|> ${2:function}")

-- Code snippet for function composition.
vimsnip.add("composition", "(${1:fonction} ∘ ${2:fonction})(${3:args})")
vimsnip.add("fcomp", "(${1:fonction} ∘ ${2:fonction})(${3:args})")

-- Code snippet for module block.
vimsnip.add("module", "module ${1:name}\nexport ${2:struct}\nstruct ${2:struct} end\n\t$0\nend")
vimsnip.add("mod", "module ${1:name}\nexport ${2:struct}\nstruct ${2:struct} end\n\t$0\nend")

-- Code snippet for module block.
vimsnip.add("baremodule", "baremodule ${1:name}\n\t$0\nend")
vimsnip.add("bmod", "baremodule ${1:name}\n\t$0\nend")
vimsnip.add("bare", "baremodule ${1:name}\n\t$0\nend")

-- Code snippet for struct block.
vimsnip.add("struct", "struct ${1:struct} <: ${2:type}\n\t$0\nend")

-- Code snippet for mutable struct block.
vimsnip.add("mutable", "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend")
vimsnip.add("mut", "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend")
vimsnip.add("mstruct", "mutable struct ${1:struct} <: ${2:type}\n\t$0\nend")

-- Code snippet for parse an expression.
vimsnip.add("meta", 'Meta.parse("{$1:expression}")')
vimsnip.add("parse", 'Meta.parse("{$1:expression}")')

-- Code snippet for using a package.
vimsnip.add("using", "using $0")
vimsnip.add("us", "using $0")

-- Code snippet for import a package.
vimsnip.add("import", "import $0")
vimsnip.add("im", "import $0")

-- Code snippet for using something from a package.
vimsnip.add("using", "using ${1:package}: ${2:exports}")
vimsnip.add("from", "using ${1:package}: ${2:exports}")
vimsnip.add("us", "using ${1:package}: ${2:exports}")

-- Code snippet for import something from a package.
vimsnip.add("import", "import ${1:package}: ${2:exports}")
vimsnip.add("from", "import ${1:package}: ${2:exports}")
vimsnip.add("im", "import ${1:package}: ${2:exports}")

-- Code snippet for using a package and rename.
vimsnip.add("using", "using ${1:package} as ${2:name}")
vimsnip.add("as", "using ${1:package} as ${2:name}")
vimsnip.add("us", "using ${1:package} as ${2:name}")

-- Code snippet for import a package and rename.
vimsnip.add("import", "import ${1:package} as ${2:name}")
vimsnip.add("as", "import ${1:package} as ${2:name}")
vimsnip.add("im", "import ${1:package} as ${2:name}")

-- Code snippet for using something from a package and rename.
vimsnip.add("using", "using ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("from", "using ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("as", "using ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("us", "using ${1:package}: ${2:exports} as ${3:name}")

-- Code snippet for import something from a package and rename.
vimsnip.add("import", "import ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("from", "import ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("as", "import ${1:package}: ${2:exports} as ${3:name}")
vimsnip.add("im", "import ${1:package}: ${2:exports} as ${3:name}")

-- An example for ccal.
vimsnip.add(
  "ccal",
  "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)"
)
vimsnip.add(
  "cfun",
  "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)"
)
vimsnip.add(
  "cfunction",
  "function ${1:name}(a, b)::Cint\n\treturn a + b\nend\n\n${1:name}_c = @cfunction(${1:name}, Cint, (Cint, Cint))\nccall(${1:name}_c, Cint, (Cint, Cint), 1, 1)"
)

-- Code snippet for calling the clock function from the standard C library.
vimsnip.add("cclock", "ccall(:clock, Int32, ())")
vimsnip.add("clock", "ccall(:clock, Int32, ())")
