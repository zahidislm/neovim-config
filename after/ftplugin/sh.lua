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
  -- Echo a message.
  ["echo"] = 'echo "${0:message}"',

  -- Read input of ${VAR}.
  ["read"] = "read -r ${0:VAR}",

  -- An IF statement.
  ["if"] = "if [[ ${1:condition} ]]; then\n\t${0}\nfi",

  -- Add an elseif to an if statement.
  ["elseif"] = "elif [[ ${1:condition} ]]; then\n\t${0}",

  -- else
  ["else"] = "else\n\t${0:command}",

  -- for loop in list
  ["for_in"] = 'for ${1:VAR} in ${0:LIST}\ndo\n\techo "\\$${1:VAR}"\ndone\n',

  -- An index-based iteration for loop.
  ["for_i"] = 'for ((${1:i} = 0; ${1:i} < ${0:10}; ${1:i}++)); do\n\techo "\\$${1:i}"\ndone\n',

  -- A while loop by condition.
  ["while"] = "while [[ ${1:condition} ]]; do\n\t${0}\ndone\n",

  -- until loop by condition
  ["until"] = "until [[ ${1:condition} ]]; do\n\t${0}\ndone\n",

  -- ['This defines a function named name.\n', 'The reserved word function is optional.\n', 'If the function reserved word is supplied, the parentheses are optional.\n', '1. Recommended way:\n', 'name() {}\n', '2. C-like-way:\nfunction name [()] {}']
  ["function"] = "${1:name} ()\n{\n\t${0}\n}",

  -- ['case word in [ [(] pattern [ | pattern ] ... ) list ;; ] ... esac\n', 'A case command first expands word, and tries to match it against each pattern in turn.']
  ["case"] = 'case "\\$${1:VAR}" in\n\t${2:1}) echo 1\n\t;;\n\t${3:2|3}) echo 2 or 3\n\t;;\n\t*) echo default\n\t;;\nesac\n',

  -- ['The break command tells Bash to leave the loop straight away.\n', 'Enter the break or break (n) where n=number of loops.']
  ["break"] = "break ${0}",

  -- Calculate numbers with Bash.
  ["expr"] = "expr ${0:1 + 1}",

  -- ['Shebang to specify what shell is going to run the script by default. It includes a description of the script. \n\nIt must be defined in the first line of the script.\n\nBy using #!/usr/bin/env we are making the shebang portable, meaning it is going to work correctly even if the interpreter is not located under /usr/bin']
  ["#!/usr/bin/env"] = "#!/usr/bin/env ${1:sh}\n#\n# ${2:Description of the script.}$0",

  -- A shell comment block for functions, including description, globals, arguments, outputs, and returns. For functions without I/O, use the simple version of this snippet instead.  You can delete 'Globals'/'Arguments'/'Outputs' in functions with no input/output.  It doesn't includes, but accepts the optional keywords:   'See'   'Raises'
  ["###"] = "#######################################\n# ${1:Description of the function.}$0\n# Globals:\n#   ${3:MY_VAR}\n# Arguments:\n#   ${4:None}\n# Outputs:\n#   ${5:Output to STDOUT or STDERR.}\n# Returns:\n#   ${2: Description of the returned value.}\n#######################################",

  -- A simple shell comment block for functions, with a description. Useful when the user prefers to add the other documentation tags manually.
  ["##"] = "#######################################\n# ${1:Description of the function.}$0\n#######################################",
})
