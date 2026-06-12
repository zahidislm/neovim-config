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

-- Convenient comment block
vimsnip.add("/", "/*$0 */")

-- Convenient multiline comment
vimsnip.add("//", "/*$0\n */")

-- Standard starter template for a tiny C program
vimsnip.add(
  "st",
  "#include <stdbool.h>\n#include <stdio.h>\n#include <stdlib.h>\n\nint main(int argc, char *argv[])\n{$0\n\treturn EXIT_SUCCESS;\n}"
)

-- Preprocessor starter template for a C project
vimsnip.add(
  "#st",
  "#include <assert.h>\n#include <errno.h>\n#include <stdbool.h>\n#include <stddef.h>\n#include <stdint.h>\n#include <stdio.h>\n#include <stdlib.h>"
)

-- Standard main() snippet
vimsnip.add("main", "int main(int argc, char *argv[])\n{$0\n\treturn EXIT_SUCCESS;\n}")

-- No-args main() snippet
vimsnip.add("mainn", "int main(void)\n{$0\n\treturn EXIT_SUCCESS;\n}")

-- #include <...> snippet
vimsnip.add("#inc", "#include <$0>")

-- #include "..." snippet
vimsnip.add("#incl", '#include "$0"')

-- Textual macro snippet
vimsnip.add("#def", "#define ${1:MACRO}")

-- Function-like macro snippet
vimsnip.add("#deff", "#define ${1:MACRO}($2) ($3)")

-- Enable GNU extensions (functions)
vimsnip.add("#gnu", "#define _GNU_SOURCE")

-- #if snippet
vimsnip.add("#if", "#if ${1:0}\n$0\n#endif /* if $1 */")

-- #ifdef snippet
vimsnip.add("#ifdef", "#ifdef ${1:MACRO}\n$0\n#endif /* ifdef $1 */")

-- #ifndef snippet
vimsnip.add("#ifndef", "#ifndef ${1:MACRO}\n$0\n#endif /* ifndef $1 */")

-- Header include guard
vimsnip.add(
  "#once", "#ifndef ${1:FILE}_H\n#define $1_H\n$0\n\n#endif /* end of include guard: $1_H */"
)

-- Disable C++ name mangling in C headers
vimsnip.add(
  "#nocpp",
  '#ifdef __cplusplus\nextern "C" {\n#endif\n$0\n\n#ifdef __cplusplus\n} /* extern "C" */\n#endif'
)

-- #error snippet
vimsnip.add("#err", '#error "$0"')

-- #warning snippet
vimsnip.add("#warn", '#warning "$0"')

-- 'if' snippet
vimsnip.add("if", "if (${1:true}) {$0\n}")

-- 'if' with 'else'
vimsnip.add("ifelse", "if (${1:true}) {$2\n} else {$0\n}")

-- 'else' snippet
vimsnip.add("else", "else {$0\n}")

-- else-if snippet
vimsnip.add("elseif", "else if (${1:true}) {$0\n}")

-- 1-line-if
vimsnip.add("ifi", "if (${1:true})$0")

-- 1-line-else-if
vimsnip.add("elseifi", "else if (${1:true})$0")

-- 'switch' snippet
vimsnip.add("switch", "switch (${1:expression}) {$0\n}")

-- 'case' branch
vimsnip.add("case", "case ${1:0}:$0")

-- 'default' branch
vimsnip.add("default", "default:$0")

-- 'while' loop snippet
vimsnip.add("while", "while (${1:true}) {$0\n}")

-- do...while loop snippet
vimsnip.add("do", "do {$0\n} while (${1:false});")

-- 'return' snippet
vimsnip.add("return", "return ${1:0};")

-- exit() snippet
vimsnip.add("exit", "exit(${1:EXIT_FAILURE});")

-- Generic 'for' loop
vimsnip.add("for", "for ($1;$2;$3) {$0\n}")

-- 'for' loop focusing on iteration times
vimsnip.add("forc", "for (${1:size_t} ${2:i} = ${3:0}; $2 < ${4:count}; $2${5:++}) {$0\n}")

-- 'for' loop focusing on inclusive range
vimsnip.add("forg", "for (${1:size_t} ${2:i} = ${3:1}; $2 <= ${4:last}; $2${5:++}) {$0\n}")

-- 'for' loop for cmdline arguments
vimsnip.add("fora", "for (int ${1:i} = ${2:1}; $1 < argc; $1++) {$0\n}")

-- Make a function declaration/definition/pointer
vimsnip.add("fun", "${2:void} ${1:fun}(${3:void})$0")

-- Define a function
vimsnip.add("func", "${2:void} ${1:fun}(${3:void})\n{$0\n}")

-- 'typedef' snippet
vimsnip.add("typedef", "typedef ${1:void} ${2:Emptiness};")

-- Declaration-like typedef for func-ptr,array,etc.
vimsnip.add("typedeff", "typedef $0;")

-- Implicit struct typedef
vimsnip.add("typedefst", "typedef struct $1 ${1:Box};")

-- Implicit union typedef
vimsnip.add("typedefun", "typedef union $1 ${1:Cell};")

-- 'struct' snippet
vimsnip.add("struct", "struct ${1:MyStruct} {$0\n};")

-- Define a type with struct
vimsnip.add("typestruct", "typedef struct $1 ${1:Box};\nstruct $1 {$0\n};")

-- 'union' snippet
vimsnip.add("union", "union ${1:MyUnion} {$0\n};")

-- Define a type with union
vimsnip.add("typeunion", "typedef union $1 ${1:Cell};\nunion $1 {$0\n};")

-- Define an enumeration
vimsnip.add("enum", "enum $1{ $0 };")

-- puts() snippet
vimsnip.add("puts", 'puts("${1:This function doesn\'t need newline.}");$0')

-- puts() snippet
vimsnip.add("fputs", 'fputs("${2:This is a simpler printf.\\n}", ${1:stdout});$0')

-- printf() snippet
vimsnip.add("printf", 'printf("${1:%s}\\n"$2);$0')

-- fprintf() snippet
vimsnip.add("fprintf", 'fprintf(${1:stderr}, "${2:%s}\\n"$3);$0')

-- sprintf() snippet
vimsnip.add("sprintf", 'sprintf(${1:buf}, "${2:%s}\\n"$3);$0')

-- snprintf() snippet
vimsnip.add("snprintf", 'snprintf(${1:buf}, ${2:max}, "${3:%s}\\n"$3);$0')

-- scanf() snippet
vimsnip.add("scanf", 'scanf("${1:%d}"$2);$0')

-- fscanf() snippet
vimsnip.add("fscanf", 'fscanf(${1:stdin}, "${2:%d}"$3);$0')

-- sscanf() snippet
vimsnip.add("sscanf", 'sscanf(${1:buf}, "${2:%d}"$3);$0')

-- malloc() snippet
vimsnip.add("malloc", "malloc(sizeof(${1:int[69]})$2);$0")

-- calloc() snippet
vimsnip.add("calloc", "calloc(${1:1}, sizeof(${2:int})$3);$0")

-- realloc() snippet
vimsnip.add("realloc", "realloc(${1:ptr}, sizeof(${2:int[69]})$3);$0")

-- reallocarray() snippet
vimsnip.add("reallocarray", "reallocarray(${1:ptr}, ${2:69}, sizeof(${3:int})$4);$0")

-- free() snippet
vimsnip.add("free", "free(${1:NULL});")

-- assert() snippet
vimsnip.add("assert", "assert($0);")

-- static_assert() snippet
vimsnip.add("static_assert", 'static_assert(${1:false}, "${2:Oopsie}");')

-- err() snippet
vimsnip.add("err", 'err(${1:EXIT_FAILURE}, "${2:%s}"$0);')

-- errx() snippet
vimsnip.add("errx", 'errx(${1:EXIT_FAILURE}, "${2:%s}"$0);')

-- warn() snippet
vimsnip.add("warn", 'warn("${1:%s}"$0);')

-- warnx() snippet
vimsnip.add("warnx", 'warnx("${1:%s}"$0);')

-- Error checking for int IO functions
vimsnip.add(
  "chkio_eof", 'if (${1:status} == EOF$2) {\n\t${3:err(EXIT_FAILURE, "IO is hard");}\n}'
)

-- Error checking for pointer-type IO functions
vimsnip.add(
  "chkio_null", 'if (!${1:status}) {\n\t${2:err(EXIT_FAILURE, "IO is very hard");}\n}'
)

-- Error checking for fseek(), getline() like functions
vimsnip.add(
  "chkio_mi", 'if (${1:status} == -1$2) {\n\t${3:err(EXIT_FAILURE, "IO is super hard");}\n}'
)

-- Error checking for printf()-like functions
vimsnip.add(
  "chkio_neg", 'if (${1:status} < 0$2) {\n\t${3:err(EXIT_FAILURE, "Ran out of ink");}\n}'
)

-- Error checking for malloc()-like
vimsnip.add(
  "chkmem", 'if (!${1:status}) {\n\t${2:err(EXIT_FAILURE, "Your memory is doomed");}\n}'
)

-- Call printf() to log value of a variable
vimsnip.add("printv", 'printf("$1 = %${2:d}\\n", ${1:var}$3);')

-- Calculate number of elements in an array
vimsnip.add("arrlen", "(sizeof ${1:arr} / sizeof $1[0])")

-- A C comment block for functions, including short summary, details, param, return, and example.
vimsnip.add(
  "/**",
  "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n *\n * @param ${4:name} ${5:Type and description of the parameter.}\n * @return ${3:Type and description of the returned value.}\n *\n * @example\n * // ${6:Description of my example.}\n * ${7:Write me later}\n */"
)

-- A simple C comment block for functions, including short summary, and details. Useful when you prefer to add the other documentation tags manually.
vimsnip.add("/*", "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n */")

-- Type and description of a function parameter.
vimsnip.add("@param", "@param ${1:name} ${2:Type and description of the parameter.}$0")

-- Type and description of the returned value.
vimsnip.add("@return", "@return ${1:Type and description of the returned value.}$0")

-- Example that demostrates how to use a function. It can be used several times.
vimsnip.add(
  "@example", "* @example\n* // ${1:Description of my example.}$0\n* ${2:Write me later}"
)

-- Anything worth mentioning that wouldn't fit in the description, or other documentation tags.
vimsnip.add("@note", "@note ${1:Text.}$0")

-- Indicates special considerations when using the function.
vimsnip.add("@warning", "@warning ${1:Text.}$0")

-- References another function, or piece of documentation.
vimsnip.add("@see", "@see ${1:Text.}$0")

-- Marks the function as deprecated, and no longer recommended for use.
vimsnip.add("@deprecated", "@deprecated ${1:Text.}$0")

-- Used to mark areas of the code that require improvement.
vimsnip.add("@todo", "@todo ${1:Text.}$0")

-- Used to mark areas of the code that require fixing.
vimsnip.add("@fixme", "@fixme ${1:Text.}$0")
