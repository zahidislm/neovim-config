-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- List comprehension for creating a list based on existing lists.
vimsnip.add("lc", "[${3:value} for ${2:value} in ${1:iterable}]$0")

-- List comprehension for creating a list based on existing lists, with conditional if-else statement.
vimsnip.add(
  "lcie", "[${3:value} if ${4:condition} else ${5:condition} for ${2:value} in ${1:iterable}]$0"
)

-- List comprehension for creating a list based on existing lists, with conditional if statement.
vimsnip.add("lci", "[${3:value} for ${2:value} in ${1:iterable} if ${4:condition}$0]")

-- Handy and faster way to create dictionaries based on existing dictionaries.
vimsnip.add("dc", "{${4:key}: ${5:value} for ${2:key}, ${3:value} in ${1:iterable}}$0")

-- Handy and faster way to create dictionaries based on existing dictionaries, with conditional if statement.
vimsnip.add(
  "dci", "{${4:key}: ${5:value} for ${2:key}, ${3:value} in ${1:iterable} if ${6:condition}}$0"
)

-- Create a set based on existing iterables.
vimsnip.add("sc", "{${3:value} for ${2:value} in ${1:iterable}}$0")

-- Create a set based on existing iterables, with condition if statement.
vimsnip.add("sci", "{${3:value} for ${2:value} in ${1:iterable} if ${4:condition}}$0")

-- Create a generator based on existing iterables.
vimsnip.add("gc", "(${3:key} for ${2:value} in ${1:iterable})$0")

-- Create a generator based on existing iterables, with condition if statement.
vimsnip.add("gci", "(${3:key} for ${2:value} in ${1:iterable} if ${4:condition})$0")

-- Code snippet for pdb debug
vimsnip.add("pdb", '__import__("pdb").set_trace()$0')

-- Code snippet for ipdb debug
vimsnip.add("ipdb", '__import__("ipdb").set_trace()$0')

-- rPDB set trace
vimsnip.add("rpdb", 'import rpdb2; rpdb2.start_embedded_debugger("${1:debug_password}")$0')

-- Code snippet for pudb debug
vimsnip.add("pudb", "import pudb; pudb.set_trace()$0")

-- IPython set trace
vimsnip.add("ipydb", "from IPython import embed; embed()$0")

-- Code snippet for celery remote debugger breakpoint
vimsnip.add("rdb", "from celery.contrib import rdb; rdb.set_trace()$0")

-- Pretty print
vimsnip.add("pprint", '__import__("pprint").pprint(${1:expression})$0')

-- Code snippet for debugpy remote attach
vimsnip.add(
  "debugpy",
  'import debugpy, platform\ndebugpy.listen((platform.node(), ${1:5678}))\nprint(f"debugpy listening on {platform.node()}:$1", flush=True)\ndebugpy.wait_for_client()$0'
)

-- A Python docstring for functions and methods, including short summary, details, args, returns, and examples. This docstring is an synonym of """function.
vimsnip.add(
  "doc#",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${4:argument_name}: ${5:type and description.}\n\nReturns:\n    ${3:type and description of the returned object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""'
)

-- A simple Python docstring comment. Useful when you prefer to add the docstrings manually on functions.
vimsnip.add("doc", '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n"""')

-- A Python docstring for modules, including a one-line summary, details, and example.
vimsnip.add(
  "docmod",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nExamples:\n\t# ${3:Description of my example.}\n\t${4:use_it_this_way(arg1, arg2)}\n"""'
)

-- Module-level docstrings for test files are not required. They should be included only when there is additional information that can be provided.  Examples include some specifics on how the test should be run, an explanation of an unusual setup pattern, dependency on the external environment, and so on. Docstrings that do not provide any new information should not be used, such as """Tests for foo.bar."""
vimsnip.add("doctest", '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n"""')

-- A Python docstring for functions and methods, including short summary, details, args, returns, and example.
vimsnip.add(
  "docfunc",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n ${4:argument_name}: ${5:type and description.}\n\nReturns:\n    ${3:type and description of the returned object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""'
)

-- Alternative Python docstring for functions and methods, with a different type syntax. Some teams prefer it.
vimsnip.add(
  "doctypfunc",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${5:argument_name} (${6:type}): ${7:description.}\n\nReturns:\n    ${3:type}: {4:Description of the returned object.}\n\nExample:\n    # ${8:Description of my example.}\n    ${9:use_it_this_way(arg1, arg2)}\n"""'
)

-- A Python docstring for generator methods, including a one-line summary, details, parameters, yields, and example. It is the same, but it has yields instead of returns.
vimsnip.add(
  "docgen",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${4:argument_name}: ${5:type and description.}\n\nYields:\n    ${3:type and description of the yielded object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""'
)

-- A Python docstring for classes, including a one-line summary, details, attributes, and returns.
vimsnip.add(
  "docclass",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nAttributes:\n    ${3:attribute_name}: ${4:type and description.}\n"""'
)

-- A Python docstring for exceptions, including a one-line summary, description, and attributes.
vimsnip.add(
  "docexcept",
  '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nAttributes:\n    ${3:attribute_name}: ${4:type and description.}\n"""'
)

-- A Python docstring for methods when we want to be exclicit about the errors it Raises. Use it only when is relevant.
vimsnip.add("docraise", "Raises:\n    ${1:ErrorName}: ${2:Error description.}$0")

-- Shebang line for the first python in PATH
vimsnip.add("pyenv", "#!/usr/bin/env python$0")

-- Snippet to avoid autopair plugin annoyances when typing multiple "
vimsnip.add("#", '"""$0\n"""')

-- Snippet to avoid autopair plugin annoyances when typing multiple "
vimsnip.add("##", '"""$0"""')

-- Snippet to reference the self property in an object
vimsnip.add("s", "self.$0")

-- Create magic method
vimsnip.add("__", "__${1:init}__$0")

-- Execute code if the file is executed directly
vimsnip.add("ifmain", 'if __name__ == "__main__":\n\t${1:main()}')

-- Import a package or module
vimsnip.add("import", "import ${1:datetime}")

-- Import individual objects directly into the caller’s symbol table
vimsnip.add("fromim", "from ${1:pathlib} import ${2:Path}")

-- if statement
vimsnip.add("if", "if ${1:condition}:\n\t${2:pass}")

-- elif statement
vimsnip.add("elif", "elif ${1:expression}:\n\t${2:pass}")

-- else statement
vimsnip.add("else", "else:\n\t${1:pass}")

-- if statement with else
vimsnip.add("ifelse", "if ${1:condition}:\n\t${2:pass}\nelse:\n\t${3:pass}")

-- match/case statements
vimsnip.add("match", "match ${1:expression}:\n\tcase ${2:pattern}:\n\t\t${3:pass}")

-- case block
vimsnip.add("case", "case ${2:pattern}:\n\t${3:pass}")

-- case wildcard block if other cases fail
vimsnip.add("casew", "case _:\n\t${1:pass}")

-- while loop
vimsnip.add("while", "while ${1:condition}:\n\t${2:pass}")

-- for loop
vimsnip.add("for", "for ${1:value} in ${2:iterable}:\n\t${3:pass}")

-- for loop that iterates over range of integers
vimsnip.add("forr", "for ${1:value} in range($2):\n\t${3:pass}")

-- 'with' statement
vimsnip.add("with", "with ${1:expression} as ${2:target}:\n\t${3:pass}")

-- lambda statement
vimsnip.add("lambda", "lambda ${1:parameter_list}: ${2:expression}")

-- Function definition
vimsnip.add("def", "def ${1:fname}($2):\n\t${3:pass}")

-- Function definition with return type
vimsnip.add("deft", "def ${1:fname}($2) -> ${3:None}:\n\t${4:pass}")

-- Class definition
vimsnip.add("class", "class ${1:classname}:\n\t${2:pass}")

-- Class definition with inheritance
vimsnip.add("classd", "class ${1:classname}($2):\n\t${3:pass}")

-- Class definition template
vimsnip.add(
  "classi",
  'class ${1:ClassName}($2):\n\t"""${3:docstring for $1.}"""\n\tdef __init__(self, ${4:arg}):\n\t\t${5:super($1, self).__init__()}\n\t\tself.$4 = $4$0'
)

-- Class method definition
vimsnip.add("defs", "def ${1:mname}(self$2):\n\t${3:pass}")

-- Class method definition
vimsnip.add("defst", "def ${1:mname}(self$2) -> ${3:None}:\n\t${4:pass}")

-- New property: get and set via decorator
vimsnip.add(
  "property",
  '@property\ndef ${1:pname}(self):\n\t"""${2:The $1 property.}"""\n\t${3:return self._$1}\n\n@${4:$1}.setter\ndef ${5:$1}(self, value):\n\t${6:self._$1} = value'
)

-- except statement
vimsnip.add("except", "except$1:\n\t${2:pass}")

-- 'except as' statement
vimsnip.add("exceptas", "except ${1:Exception} as ${2:e}:\n\t${3:raise $2}")

-- try/except blocks
vimsnip.add("try", "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}")

-- try/except/else blocks
vimsnip.add(
  "trya", "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}\nelse:\n\t${5:pass}"
)

-- try/except/finally blocks
vimsnip.add(
  "tryf",
  "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}\nfinally:\n\t${5:pass}"
)

-- try/except/else/finally blocks
vimsnip.add(
  "tryef",
  "try:\n\t${1:pass}\nexcept${2: ${3:Exception} as ${4:e}}:\n\t${5:raise}\nelse:\n\t${6:pass}\nfinally:\n\t${7:pass}"
)

-- Assert equal
vimsnip.add("ase", 'self.assertEqual(${1:expected}, ${2:actual}${3:, "${4:message}"})$0')

-- Assert not equal
vimsnip.add("asne", 'self.assertNotEqual(${1:expected}, ${2:actual}${3:, "${4:message}"})$0')

-- Assert raises
vimsnip.add("asr", "self.assertRaises(${1:exception}, ${2:callable}, ${3:args})$0")

-- Assert True
vimsnip.add("ast", 'self.assertTrue(${1:actual}${2:, "${3:message}"})$0')

-- Assert False
vimsnip.add("asf", 'self.assertFalse(${1:actual}${2:, "${3:message}"})$0')

-- Assert is
vimsnip.add("asi", 'self.assertIs(${1:expected}, ${2:actual}${3:, "${4:message}"})$0')

-- Assert is not
vimsnip.add("asint", 'self.assertIsNot(${1:expected}, ${2:actual}${3:, "${4:message}"})$0')

-- Assert is None
vimsnip.add("asino", 'self.assertIsNone(${1:actual}${2:, "${3:message}"})$0')

-- Assert is not None
vimsnip.add("asinno", 'self.assertIsNotNone(${1:actual}${2:, "${3:message}"})$0')

-- Assert in
vimsnip.add("asin", 'self.assertIn(${1:needle}, ${2:haystack}${3:, "${4:message}"})$0')

-- Assert not in
vimsnip.add("asni", 'self.assertNotIn(${1:needle}, ${2:haystack}${3:, "${4:message}"})$0')

-- Assert
vimsnip.add("as", 'self.assert_(${1:boolean expression}${2:, "${3:message}"})$0')

-- Fail (a test)
vimsnip.add("fail", 'self.fail("${1:message}")$0')
