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
  -- Convenient comment block
  ["/"] = "/*$0 */",

  -- Convenient multiline comment
  ["//"] = "/*$0\n */",

  -- Standard starter template for a tiny C program
  ["st"] = "#include <stdbool.h>\n#include <stdio.h>\n#include <stdlib.h>\n\nint main(int argc, char *argv[])\n{$0\n\treturn EXIT_SUCCESS;\n}",

  -- Preprocessor starter template for a C project
  ["#st"] = "#include <assert.h>\n#include <errno.h>\n#include <stdbool.h>\n#include <stddef.h>\n#include <stdint.h>\n#include <stdio.h>\n#include <stdlib.h>",

  -- Standard main() snippet
  ["main"] = "int main(int argc, char *argv[])\n{$0\n\treturn EXIT_SUCCESS;\n}",

  -- No-args main() snippet
  ["mainn"] = "int main(void)\n{$0\n\treturn EXIT_SUCCESS;\n}",

  -- #include <...> snippet
  ["#inc"] = "#include <$0>",

  -- #include "..." snippet
  ["#incl"] = '#include "$0"',

  -- Textual macro snippet
  ["#def"] = "#define ${1:MACRO}",

  -- Function-like macro snippet
  ["#deff"] = "#define ${1:MACRO}($2) ($3)",

  -- Enable GNU extensions (functions)
  ["#gnu"] = "#define _GNU_SOURCE",

  -- #if snippet
  ["#if"] = "#if ${1:0}\n$0\n#endif /* if $1 */",

  -- #ifdef snippet
  ["#ifdef"] = "#ifdef ${1:MACRO}\n$0\n#endif /* ifdef $1 */",

  -- #ifndef snippet
  ["#ifndef"] = "#ifndef ${1:MACRO}\n$0\n#endif /* ifndef $1 */",

  -- Header include guard
  ["#once"] = "#ifndef ${1:FILE}_H\n#define $1_H\n$0\n\n#endif /* end of include guard: $1_H */",

  -- Disable C++ name mangling in C headers
  ["#nocpp"] = '#ifdef __cplusplus\nextern "C" {\n#endif\n$0\n\n#ifdef __cplusplus\n} /* extern "C" */\n#endif',

  -- #error snippet
  ["#err"] = '#error "$0"',

  -- #warning snippet
  ["#warn"] = '#warning "$0"',

  -- 'if' snippet
  ["if"] = "if (${1:true}) {$0\n}",

  -- 'if' with 'else'
  ["ifelse"] = "if (${1:true}) {$2\n} else {$0\n}",

  -- 'else' snippet
  ["else"] = "else {$0\n}",

  -- else-if snippet
  ["elseif"] = "else if (${1:true}) {$0\n}",

  -- 1-line-if
  ["ifi"] = "if (${1:true})$0",

  -- 1-line-else-if
  ["elseifi"] = "else if (${1:true})$0",

  -- 'switch' snippet
  ["switch"] = "switch (${1:expression}) {$0\n}",

  -- 'case' branch
  ["case"] = "case ${1:0}:$0",

  -- 'default' branch
  ["default"] = "default:$0",

  -- 'while' loop snippet
  ["while"] = "while (${1:true}) {$0\n}",

  -- do...while loop snippet
  ["do"] = "do {$0\n} while (${1:false});",

  -- 'return' snippet
  ["return"] = "return ${1:0};",

  -- exit() snippet
  ["exit"] = "exit(${1:EXIT_FAILURE});",

  -- Generic 'for' loop
  ["for"] = "for ($1;$2;$3) {$0\n}",

  -- 'for' loop focusing on iteration times
  ["forc"] = "for (${1:size_t} ${2:i} = ${3:0}; $2 < ${4:count}; $2${5:++}) {$0\n}",

  -- 'for' loop focusing on inclusive range
  ["forg"] = "for (${1:size_t} ${2:i} = ${3:1}; $2 <= ${4:last}; $2${5:++}) {$0\n}",

  -- 'for' loop for cmdline arguments
  ["fora"] = "for (int ${1:i} = ${2:1}; $1 < argc; $1++) {$0\n}",

  -- Make a function declaration/definition/pointer
  ["fun"] = "${2:void} ${1:fun}(${3:void})$0",

  -- Define a function
  ["func"] = "${2:void} ${1:fun}(${3:void})\n{$0\n}",

  -- 'typedef' snippet
  ["typedef"] = "typedef ${1:void} ${2:Emptiness};",

  -- Declaration-like typedef for func-ptr,array,etc.
  ["typedeff"] = "typedef $0;",

  -- Implicit struct typedef
  ["typedefst"] = "typedef struct $1 ${1:Box};",

  -- Implicit union typedef
  ["typedefun"] = "typedef union $1 ${1:Cell};",

  -- 'struct' snippet
  ["struct"] = "struct ${1:MyStruct} {$0\n};",

  -- Define a type with struct
  ["typestruct"] = "typedef struct $1 ${1:Box};\nstruct $1 {$0\n};",

  -- 'union' snippet
  ["union"] = "union ${1:MyUnion} {$0\n};",

  -- Define a type with union
  ["typeunion"] = "typedef union $1 ${1:Cell};\nunion $1 {$0\n};",

  -- Define an enumeration
  ["enum"] = "enum $1{ $0 };",

  -- puts() snippet
  ["puts"] = 'puts("${1:This function doesn\'t need newline.}");$0',

  -- puts() snippet
  ["fputs"] = 'fputs("${2:This is a simpler printf.\\n}", ${1:stdout});$0',

  -- printf() snippet
  ["printf"] = 'printf("${1:%s}\\n"$2);$0',

  -- fprintf() snippet
  ["fprintf"] = 'fprintf(${1:stderr}, "${2:%s}\\n"$3);$0',

  -- sprintf() snippet
  ["sprintf"] = 'sprintf(${1:buf}, "${2:%s}\\n"$3);$0',

  -- snprintf() snippet
  ["snprintf"] = 'snprintf(${1:buf}, ${2:max}, "${3:%s}\\n"$3);$0',

  -- scanf() snippet
  ["scanf"] = 'scanf("${1:%d}"$2);$0',

  -- fscanf() snippet
  ["fscanf"] = 'fscanf(${1:stdin}, "${2:%d}"$3);$0',

  -- sscanf() snippet
  ["sscanf"] = 'sscanf(${1:buf}, "${2:%d}"$3);$0',

  -- malloc() snippet
  ["malloc"] = "malloc(sizeof(${1:int[69]})$2);$0",

  -- calloc() snippet
  ["calloc"] = "calloc(${1:1}, sizeof(${2:int})$3);$0",

  -- realloc() snippet
  ["realloc"] = "realloc(${1:ptr}, sizeof(${2:int[69]})$3);$0",

  -- reallocarray() snippet
  ["reallocarray"] = "reallocarray(${1:ptr}, ${2:69}, sizeof(${3:int})$4);$0",

  -- free() snippet
  ["free"] = "free(${1:NULL});",

  -- assert() snippet
  ["assert"] = "assert($0);",

  -- static_assert() snippet
  ["static_assert"] = 'static_assert(${1:false}, "${2:Oopsie}");',

  -- err() snippet
  ["err"] = 'err(${1:EXIT_FAILURE}, "${2:%s}"$0);',

  -- errx() snippet
  ["errx"] = 'errx(${1:EXIT_FAILURE}, "${2:%s}"$0);',

  -- warn() snippet
  ["warn"] = 'warn("${1:%s}"$0);',

  -- warnx() snippet
  ["warnx"] = 'warnx("${1:%s}"$0);',

  -- Error checking for int IO functions
  ["chkio_eof"] = 'if (${1:status} == EOF$2) {\n\t${3:err(EXIT_FAILURE, "IO is hard");}\n}',

  -- Error checking for pointer-type IO functions
  ["chkio_null"] = 'if (!${1:status}) {\n\t${2:err(EXIT_FAILURE, "IO is very hard");}\n}',

  -- Error checking for fseek(), getline() like functions
  ["chkio_mi"] = 'if (${1:status} == -1$2) {\n\t${3:err(EXIT_FAILURE, "IO is super hard");}\n}',

  -- Error checking for printf()-like functions
  ["chkio_neg"] = 'if (${1:status} < 0$2) {\n\t${3:err(EXIT_FAILURE, "Ran out of ink");}\n}',

  -- Error checking for malloc()-like
  ["chkmem"] = 'if (!${1:status}) {\n\t${2:err(EXIT_FAILURE, "Your memory is doomed");}\n}',

  -- Call printf() to log value of a variable
  ["printv"] = 'printf("$1 = %${2:d}\\n", ${1:var}$3);',

  -- Calculate number of elements in an array
  ["arrlen"] = "(sizeof ${1:arr} / sizeof $1[0])",

  -- A C comment block for functions, including short summary, details, param, return, and example.
  ["/**"] = "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n *\n * @param ${4:name} ${5:Type and description of the parameter.}\n * @return ${3:Type and description of the returned value.}\n *\n * @example\n * // ${6:Description of my example.}\n * ${7:Write me later}\n */",

  -- A simple C comment block for functions, including short summary, and details. Useful when you prefer to add the other documentation tags manually.
  ["/*"] = "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n */",

  -- Type and description of a function parameter.
  ["@param"] = "@param ${1:name} ${2:Type and description of the parameter.}$0",

  -- Type and description of the returned value.
  ["@return"] = "@return ${1:Type and description of the returned value.}$0",

  -- Example that demostrates how to use a function. It can be used several times.
  ["@example"] = "* @example\n* // ${1:Description of my example.}$0\n* ${2:Write me later}",

  -- Anything worth mentioning that wouldn't fit in the description, or other documentation tags.
  ["@note"] = "@note ${1:Text.}$0",

  -- Indicates special considerations when using the function.
  ["@warning"] = "@warning ${1:Text.}$0",

  -- References another function, or piece of documentation.
  ["@see"] = "@see ${1:Text.}$0",

  -- Marks the function as deprecated, and no longer recommended for use.
  ["@deprecated"] = "@deprecated ${1:Text.}$0",

  -- Used to mark areas of the code that require improvement.
  ["@todo"] = "@todo ${1:Text.}$0",

  -- Used to mark areas of the code that require fixing.
  ["@fixme"] = "@fixme ${1:Text.}$0",
})
