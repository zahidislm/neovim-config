-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- List comprehension for creating a list based on existing lists.
  ["lc"] = "[${3:value} for ${2:value} in ${1:iterable}]$0",

  -- List comprehension for creating a list based on existing lists, with conditional if-else statement.
  ["lcie"] = "[${3:value} if ${4:condition} else ${5:condition} for ${2:value} in ${1:iterable}]$0",

  -- List comprehension for creating a list based on existing lists, with conditional if statement.
  ["lci"] = "[${3:value} for ${2:value} in ${1:iterable} if ${4:condition}$0]",

  -- Handy and faster way to create dictionaries based on existing dictionaries.
  ["dc"] = "{${4:key}: ${5:value} for ${2:key}, ${3:value} in ${1:iterable}}$0",

  -- Handy and faster way to create dictionaries based on existing dictionaries, with conditional if statement.
  ["dci"] = "{${4:key}: ${5:value} for ${2:key}, ${3:value} in ${1:iterable} if ${6:condition}}$0",

  -- Create a set based on existing iterables.
  ["sc"] = "{${3:value} for ${2:value} in ${1:iterable}}$0",

  -- Create a set based on existing iterables, with condition if statement.
  ["sci"] = "{${3:value} for ${2:value} in ${1:iterable} if ${4:condition}}$0",

  -- Create a generator based on existing iterables.
  ["gc"] = "(${3:key} for ${2:value} in ${1:iterable})$0",

  -- Create a generator based on existing iterables, with condition if statement.
  ["gci"] = "(${3:key} for ${2:value} in ${1:iterable} if ${4:condition})$0",

  -- Code snippet for pdb debug
  ["pdb"] = '__import__("pdb").set_trace()$0',

  -- Code snippet for ipdb debug
  ["ipdb"] = '__import__("ipdb").set_trace()$0',

  -- rPDB set trace
  ["rpdb"] = 'import rpdb2; rpdb2.start_embedded_debugger("${1:debug_password}")$0',

  -- Code snippet for pudb debug
  ["pudb"] = "import pudb; pudb.set_trace()$0",

  -- IPython set trace
  ["ipydb"] = "from IPython import embed; embed()$0",

  -- Code snippet for celery remote debugger breakpoint
  ["rdb"] = "from celery.contrib import rdb; rdb.set_trace()$0",

  -- Pretty print
  ["pprint"] = '__import__("pprint").pprint(${1:expression})$0',

  -- Code snippet for debugpy remote attach
  ["debugpy"] = 'import debugpy, platform\ndebugpy.listen((platform.node(), ${1:5678}))\nprint(f"debugpy listening on {platform.node()}:$1", flush=True)\ndebugpy.wait_for_client()$0',

  -- A Python docstring for functions and methods, including short summary, details, args, returns, and examples. This docstring is an synonym of """function.
  ["doc#"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${4:argument_name}: ${5:type and description.}\n\nReturns:\n    ${3:type and description of the returned object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""',

  -- A simple Python docstring comment. Useful when you prefer to add the docstrings manually on functions.
  ["doc"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n"""',

  -- A Python docstring for modules, including a one-line summary, details, and example.
  ["docmod"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nExamples:\n\t# ${3:Description of my example.}\n\t${4:use_it_this_way(arg1, arg2)}\n"""',

  -- Module-level docstrings for test files are not required. They should be included only when there is additional information that can be provided.  Examples include some specifics on how the test should be run, an explanation of an unusual setup pattern, dependency on the external environment, and so on. Docstrings that do not provide any new information should not be used, such as """Tests for foo.bar."""
  ["doctest"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n"""',

  -- A Python docstring for functions and methods, including short summary, details, args, returns, and example.
  ["docfunc"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n ${4:argument_name}: ${5:type and description.}\n\nReturns:\n    ${3:type and description of the returned object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""',

  -- Alternative Python docstring for functions and methods, with a different type syntax. Some teams prefer it.
  ["doctypfunc"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${5:argument_name} (${6:type}): ${7:description.}\n\nReturns:\n    ${3:type}: {4:Description of the returned object.}\n\nExample:\n    # ${8:Description of my example.}\n    ${9:use_it_this_way(arg1, arg2)}\n"""',

  -- A Python docstring for generator methods, including a one-line summary, details, parameters, yields, and example. It is the same, but it has yields instead of returns.
  ["docgen"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nArgs:\n    ${4:argument_name}: ${5:type and description.}\n\nYields:\n    ${3:type and description of the yielded object.}\n\nExample:\n    # ${6:Description of my example.}\n    ${7:use_it_this_way(arg1, arg2)}\n"""',

  -- A Python docstring for classes, including a one-line summary, details, attributes, and returns.
  ["docclass"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nAttributes:\n    ${3:attribute_name}: ${4:type and description.}\n"""',

  -- A Python docstring for exceptions, including a one-line summary, description, and attributes.
  ["docexcept"] = '"""\n${1:A one-line summary.}\n\n${2:Detailed description.}$0\n\nAttributes:\n    ${3:attribute_name}: ${4:type and description.}\n"""',

  -- A Python docstring for methods when we want to be exclicit about the errors it Raises. Use it only when is relevant.
  ["docraise"] = "Raises:\n    ${1:ErrorName}: ${2:Error description.}$0",

  -- Shebang line for the first python in PATH
  ["pyenv"] = "#!/usr/bin/env python$0",

  -- Snippet to avoid autopair plugin annoyances when typing multiple "
  ["#"] = '"""$0\n"""',

  -- Snippet to avoid autopair plugin annoyances when typing multiple "
  ["##"] = '"""$0"""',

  -- Snippet to reference the self property in an object
  ["s"] = "self.$0",

  -- Create magic method
  ["__"] = "__${1:init}__$0",

  -- Execute code if the file is executed directly
  ["ifmain"] = 'if __name__ == "__main__":\n\t${1:main()}',

  -- Import a package or module
  ["import"] = "import ${1:datetime}",

  -- Import individual objects directly into the caller’s symbol table
  ["fromim"] = "from ${1:pathlib} import ${2:Path}",

  -- if statement
  ["if"] = "if ${1:condition}:\n\t${2:pass}",

  -- elif statement
  ["elif"] = "elif ${1:expression}:\n\t${2:pass}",

  -- else statement
  ["else"] = "else:\n\t${1:pass}",

  -- if statement with else
  ["ifelse"] = "if ${1:condition}:\n\t${2:pass}\nelse:\n\t${3:pass}",

  -- match/case statements
  ["match"] = "match ${1:expression}:\n\tcase ${2:pattern}:\n\t\t${3:pass}",

  -- case block
  ["case"] = "case ${2:pattern}:\n\t${3:pass}",

  -- case wildcard block if other cases fail
  ["casew"] = "case _:\n\t${1:pass}",

  -- while loop
  ["while"] = "while ${1:condition}:\n\t${2:pass}",

  -- for loop
  ["for"] = "for ${1:value} in ${2:iterable}:\n\t${3:pass}",

  -- for loop that iterates over range of integers
  ["forr"] = "for ${1:value} in range($2):\n\t${3:pass}",

  -- 'with' statement
  ["with"] = "with ${1:expression} as ${2:target}:\n\t${3:pass}",

  -- lambda statement
  ["lambda"] = "lambda ${1:parameter_list}: ${2:expression}",

  -- Function definition
  ["def"] = "def ${1:fname}($2):\n\t${3:pass}",

  -- Function definition with return type
  ["deft"] = "def ${1:fname}($2) -> ${3:None}:\n\t${4:pass}",

  -- Class definition
  ["class"] = "class ${1:classname}:\n\t${2:pass}",

  -- Class definition with inheritance
  ["classd"] = "class ${1:classname}($2):\n\t${3:pass}",

  -- Class definition template
  ["classi"] = 'class ${1:ClassName}($2):\n\t"""${3:docstring for $1.}"""\n\tdef __init__(self, ${4:arg}):\n\t\t${5:super($1, self).__init__()}\n\t\tself.$4 = $4$0',

  -- Class method definition
  ["defs"] = "def ${1:mname}(self$2):\n\t${3:pass}",

  -- Class method definition
  ["defst"] = "def ${1:mname}(self$2) -> ${3:None}:\n\t${4:pass}",

  -- New property: get and set via decorator
  ["property"] = '@property\ndef ${1:pname}(self):\n\t"""${2:The $1 property.}"""\n\t${3:return self._$1}\n\n@${4:$1}.setter\ndef ${5:$1}(self, value):\n\t${6:self._$1} = value',

  -- except statement
  ["except"] = "except$1:\n\t${2:pass}",

  -- 'except as' statement
  ["exceptas"] = "except ${1:Exception} as ${2:e}:\n\t${3:raise $2}",

  -- try/except blocks
  ["try"] = "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}",

  -- try/except/else blocks
  ["trya"] = "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}\nelse:\n\t${5:pass}",

  -- try/except/finally blocks
  ["tryf"] = "try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}\nfinally:\n\t${5:pass}",

  -- try/except/else/finally blocks
  ["tryef"] = "try:\n\t${1:pass}\nexcept${2: ${3:Exception} as ${4:e}}:\n\t${5:raise}\nelse:\n\t${6:pass}\nfinally:\n\t${7:pass}",

  -- Assert equal
  ["ase"] = 'self.assertEqual(${1:expected}, ${2:actual}${3:, "${4:message}"})$0',

  -- Assert not equal
  ["asne"] = 'self.assertNotEqual(${1:expected}, ${2:actual}${3:, "${4:message}"})$0',

  -- Assert raises
  ["asr"] = "self.assertRaises(${1:exception}, ${2:callable}, ${3:args})$0",

  -- Assert True
  ["ast"] = 'self.assertTrue(${1:actual}${2:, "${3:message}"})$0',

  -- Assert False
  ["asf"] = 'self.assertFalse(${1:actual}${2:, "${3:message}"})$0',

  -- Assert is
  ["asi"] = 'self.assertIs(${1:expected}, ${2:actual}${3:, "${4:message}"})$0',

  -- Assert is not
  ["asint"] = 'self.assertIsNot(${1:expected}, ${2:actual}${3:, "${4:message}"})$0',

  -- Assert is None
  ["asino"] = 'self.assertIsNone(${1:actual}${2:, "${3:message}"})$0',

  -- Assert is not None
  ["asinno"] = 'self.assertIsNotNone(${1:actual}${2:, "${3:message}"})$0',

  -- Assert in
  ["asin"] = 'self.assertIn(${1:needle}, ${2:haystack}${3:, "${4:message}"})$0',

  -- Assert not in
  ["asni"] = 'self.assertNotIn(${1:needle}, ${2:haystack}${3:, "${4:message}"})$0',

  -- Assert
  ["as"] = 'self.assert_(${1:boolean expression}${2:, "${3:message}"})$0',

  -- Fail (a test)
  ["fail"] = 'self.fail("${1:message}")$0',
})
