-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- Standard starter template for a tiny C++ program
  ["st"] = "#include <iostream>\n\nint main (int argc, char *argv[]) {\n\t$1\n\n\treturn 0;\n}",

  -- Code snippet for reverse 'for' loop
  ["forr"] = "for (${1:size_t} ${2:i} = ${3:length} - 1; $2 >= ${4:0}; $2--) {\n\t$0\n}",

  -- Code snippet for range-based for loop (c++11) statement
  ["foreach"] = "for(${1:auto} ${2:var} : ${3:collection_to_loop}) {\n\t$0\n}",

  -- Code snippet for enum
  ["enum"] = "enum ${1:MyEnum} {\n\t$0\n};",

  -- Code snippet for enum class (c++11)
  ["enum class"] = "enum class ${1:MyClass} {$0};",

  -- Code snippet for class
  ["class"] = "class ${1:MyClass} {\npublic:\n\t$1();\n\t$1($1 &&) = default;\n\t$1(const $1 &) = default;\n\t$1 &operator=($1 &&) = default;\n\t$1 &operator=(const $1 &) = default;\n\t~$1();\n\nprivate:\n\t$2\n};\n\n$1::$1() {\n}\n\n$1::~$1() {\n}",

  -- Code snippet for empty class
  ["eclass"] = "class ${1:MyClass} {\npublic:\n\t$2\nprivate:\n\t$3\n};\n",

  -- Code snippet for empty Qt class
  ["qclass"] = "class ${1:MyClass} : public QObject {\n\tQ_OBJECT;\npublic:\n\nexplicit $1(QObject *parent = nullptr);\n\t$2\nsignals:\n\npublic slots:\n};\n",

  -- Code snippet for class with inline constructor/destructor
  ["classi"] = "class ${1:MyClass} {\npublic:\n\t$1() = default;\n\t$1($1 &&) = default;\n\t$1(const $1 &) = default;\n\t$1 &operator=($1 &&) = default;\n\t$1 &operator=(const $1 &) = default;\n\t~$1() = default;\n\nprivate:\n\t$2\n};",

  -- Code snippet for interface (Visual C++)
  ["interface"] = "__interface I${1:Interface} {\n\t$0\n};",

  -- namespace
  ["namespace"] = "namespace ${1:MyNamespace} {\n\t$0\n}",

  -- Code snippet for #ifdef
  ["#ifdef"] = "#ifdef ${1:DEBUG}\n$0\n#endif // $1",

  -- Code snippet for #ifndef
  ["#ifndef"] = "#ifndef ${1:DEBUG}\n$0\n#endif // !$1",

  -- Code snippet for #if
  ["#if"] = "#if ${1:0}\n$0\n#endif // $1",

  -- Code snippet for struct
  ["struct"] = "struct ${1:MyStruct} {\n\t$0\n};",

  -- Code snippet for switch statement
  ["switch"] = "switch (${1:switch_on}) {\n\tdefault:\n\t\t$0\n\t\tbreak;\n}",

  -- Code snippet for try catch
  ["try"] = "try {\n\t$2\n}\ncatch (${1:const std::exception&}) {\n}",

  -- Code snippet for union
  ["union"] = "union ${1:MyUnion} {\n\t$0\n};",

  -- Code snippet for printing to std::cout, provided the header is set
  ["cout"] = "std::cout << ${1:message};",

  -- Code snippet for std::cin, provided the header is set
  ["cin"] = "std::cin >> $1;",

  -- Generic printf() snippet
  ["printf"] = 'printf("$1\\n"$0);',

  -- Generic sprintf() snippet
  ["sprintf"] = 'sprintf($1, "$2\\n"$0);',

  -- Generic fprintf() snippet
  ["fprintf"] = 'fprintf(${1:stderr}, "$2\\n"$0);',

  -- Generic scanf() snippet
  ["scanf"] = 'scanf("$1"$0);',

  -- Generic sscanf() snippet
  ["sscanf"] = 'sscanf($1, "$2"$0);',

  -- Generic fscanf() snippet
  ["fscanf"] = 'fscanf($1, "$2"$0);',

  -- Code snippet for #include " "
  ["#inc"] = '#include "$1"$2',

  -- Code snippet for #include < >
  ["#inc<"] = "#include <$1>$2",

  -- Code snippet for #define " "
  ["def"] = "#define $0",

  -- A standard main function for a C++ program
  ["main"] = "int main (int argc, char *argv[]) {\n\t$1\n\treturn 0;\n}",

  -- header guard. format : 	INCLUDE_<dirname>_<filename>_<extension>_
  ["#guard"] = "#ifndef INCLUDE${TM_DIRECTORY/.*[\\/\\\\](.*)/_${1:/upcase}/}${TM_FILENAME_BASE/(.*)/_${1:/upcase}/}${TM_FILENAME/.*\\.(.*)/_${1:/upcase}/}_\n#define INCLUDE${TM_DIRECTORY/.*[\\/\\\\](.*)/_${1:/upcase}/}${TM_FILENAME_BASE/(.*)/_${1:/upcase}/}${TM_FILENAME/.*\\.(.*)/_${1:/upcase}/}_\n\n$0\n\n#endif  // INCLUDE${TM_DIRECTORY/.*[\\/\\\\](.*)/_${1:/upcase}/}${TM_FILENAME_BASE/(.*)/_${1:/upcase}/}${TM_FILENAME/.*\\.(.*)/_${1:/upcase}/}_",

  -- static_cast<type>(expression)
  ["sca"] = "static_cast<${1:unsigned}>(${2:expr})$3",

  -- dynamic_cast<type>(expression)
  ["dca"] = "dynamic_cast<${1:unsigned}>(${2:expr})$3",

  -- reinterpret_cast<type>(expression)
  ["rca"] = "reinterpret_cast<${1:unsigned}>(${2:expr})$3",

  -- const_cast<type>(expression)
  ["cca"] = "const_cast<${1:unsigned}>(${2:expr})$3",

  -- auto function and trailing return
  ["af"] = "auto ${1:name}( ${2:void} ) -> ${3:auto} {\n\t${5}\n}",

  -- A C++ comment block for functions, including description, param, return, and example.
  ["/**"] = "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n *\n * @param ${4:name} ${5:Type and description of the parameter.}\n * @return ${3:Type and description of the returned value.}\n *\n * @example\n * // ${6:Description of my example.}\n * ${7:Write me later}\n */",

  -- A simple C++ comment block for classes, including short summary, and details. Useful when you prefer to add the other documentation tags manually.
  ["/*"] = "/**\n * ${1:A one-line summary.}\n *\n * ${2:Description.}$0\n */",

  -- Type and description of a function parameter.
  ["@param"] = "@param ${1:name} ${2:Type and description of the parameter.}$0",

  -- Type and description of the returned value.
  ["@return"] = "@return ${1:Type and description of the returned value.}$0",

  -- Example that demostrates how to use a function. It can be used several times.
  ["@example"] = "@example\n* // ${1:Description of my example.}$0\n* ${2:Write me later}",

  -- Indicates the exceptions that can be thrown by a function. This tag is a synonym of @exception.
  ["@throws"] = "@throws ${1:ExceptionName} ${2:Description.}$0",

  -- Indicates the exceptions that can be thrown by a function. This tag is a synonym of @throws.
  ["@exception"] = "@exception ${1:ExceptionName} ${2:Description.}$0",
})
