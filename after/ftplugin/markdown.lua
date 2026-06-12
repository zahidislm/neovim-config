-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- Add header level 1
vimsnip.add("h1", "# ${0}")

-- Add header level 2
vimsnip.add("h2", "## ${0}")

-- Add header level 3
vimsnip.add("h3", "### ${0}")

-- Add header level 4
vimsnip.add("h4", "#### ${0}")

-- Add header level 5
vimsnip.add("h5", "##### ${0}")

-- Add header level 6
vimsnip.add("h6", "###### ${0}")

-- Add links
vimsnip.add("l", "[${1:text}](${2:url}) ${0}")
vimsnip.add("link", "[${1:text}](${2:url}) ${0}")

-- Add urls
vimsnip.add("u", "<${1}> ${0}")
vimsnip.add("url", "<${1}> ${0}")

-- Add images
vimsnip.add("img", "![${1:alt text}](${2:path}) ${0}")

-- Insert strikethrough
vimsnip.add("strikethrough", "~~${1}~~ ${0}")

-- Insert bold text
vimsnip.add("bold", "**${1}** $0")
vimsnip.add("b", "**${1}** $0")

-- Insert italic text
vimsnip.add("i", "*${1}* $0")
vimsnip.add("italic", "*${1}* $0")

-- Insert bold and italic text
vimsnip.add("boldital", "***${1}*** $0")
vimsnip.add("bi", "***${1}*** $0")

-- Insert quoted text
vimsnip.add("quote", "> ${1}")

-- Insert code
vimsnip.add("code", "`${1}` $0")

-- Insert fenced code block
vimsnip.add("codeblock", "```${1:language}\n$0\n```")

-- Insert unordered list
vimsnip.add("unordlist", "- ${1:first}\n- ${2:second}\n- ${3:third}\n$0")

-- Insert ordered list
vimsnip.add("ordlist", "1. ${1:first}\n2. ${2:second}\n3. ${3:third}\n$0")

-- Insert horizontal rule
vimsnip.add("horizrule", "----------\n")

-- Insert task list
vimsnip.add("task", "- [${1| ,x|}] ${2:text}\n${0}")

-- Insert task list with 2 tasks
vimsnip.add("task2", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n${0}")

-- Insert task list with 3 tasks
vimsnip.add(
  "task3", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n${0}"
)

-- Insert task list with 4 tasks
vimsnip.add(
  "task4",
  "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n${0}"
)

-- Insert task list with 5 tasks
vimsnip.add(
  "task5",
  "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n- [${9| ,x|}] ${10:text}\n${0}"
)

-- Insert table with 2 rows and 3 columns. First row is heading.
vimsnip.add(
  "table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} |\n| ------------- | -------------- | -------------- |\n| ${4:Item1} | ${5:Item1} | ${6:Item1} |\n${0}"
)

-- Insert table with 2 rows and 1 column. First row is heading.
vimsnip.add("2x1table", "| ${1:Column1} |\n| ------------- |\n| ${2:Item1} |\n${0}")

-- Insert table with 3 rows and 1 column. First row is heading.
vimsnip.add(
  "3x1table", "| ${1:Column1} |\n| ------------- |\n| ${2:Item1} |\n| ${3:Item2} |\n${0}"
)

-- Insert table with 4 rows and 1 column. First row is heading.
vimsnip.add(
  "4x1table",
  "| ${1:Column1} |\n| ------------- |\n| ${2:Item1} |\n| ${3:Item2} |\n| ${4:Item3} |\n${0}"
)

-- Insert table with 5 rows and 1 column. First row is heading.
vimsnip.add(
  "5x1table",
  "| ${1:Column1} |\n| ------------- |\n| ${2:Item1} |\n| ${3:Item2} |\n| ${4:Item3} |\n| ${5:Item4} |\n${0}"
)

-- Insert table with 2 rows and 2 columns. First row is heading.
vimsnip.add(
  "2x2table",
  "| ${1:Column1} | ${2:Column2} |\n| -------------- | --------------- |\n| ${3:Item1.1} | ${4:Item2.1} |\n${0}"
)

-- Insert table with 3 rows and 2 columns. First row is heading.
vimsnip.add(
  "3x2table",
  "| ${1:Column1} | ${2:Column2} |\n| -------------- | --------------- |\n| ${3:Item1.1} | ${4:Item2.1} |\n| ${5:Item1.2} | ${6:Item2.2} |\n${0}"
)

-- Insert table with 4 rows and 2 columns. First row is heading.
vimsnip.add(
  "4x2table",
  "| ${1:Column1} | ${2:Column2} |\n| -------------- | --------------- |\n| ${3:Item1.1} | ${4:Item2.1} |\n| ${5:Item1.2} | ${6:Item2.2} |\n| ${7:Item1.3} | ${8:Item2.3} |\n${0}"
)

-- Insert table with 5 rows and 2 columns. First row is heading.
vimsnip.add(
  "5x2table",
  "| ${1:Column1}   | ${2:Column2}    |\n|--------------- | --------------- |\n| ${3:Item1.1}   | ${4:Item2.1}   |\n| ${5:Item1.2}   | ${6:Item2.2}   |\n| ${7:Item1.3}   | ${8:Item2.3}   |\n| ${9:Item1.4}   | ${10:Item2.4}   |\n${0}"
)

-- Insert table with 2 rows and 3 columns. First row is heading.
vimsnip.add(
  "2x3table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} |\n| --------------- | --------------- | --------------- |\n| ${4:Item1.1} | ${5:Item2.1} | ${6:Item3.1} |\n${0}"
)

-- Insert table with 3 rows and 3 columns. First row is heading.
vimsnip.add(
  "3x3table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} |\n| --------------- | --------------- | --------------- |\n| ${4:Item1.1} | ${5:Item2.1} | ${6:Item3.1} |\n| ${7:Item1.2} | ${8:Item2.2} | ${9:Item3.2} |\n${0}"
)

-- Insert table with 4 rows and 3 columns. First row is heading.
vimsnip.add(
  "4x3table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} |\n| --------------- | --------------- | --------------- |\n| ${4:Item1.1} | ${5:Item2.1} | ${6:Item3.1} |\n| ${7:Item1.2} | ${8:Item2.2} | ${9:Item3.2} |\n| ${10:Item1.3} | ${11:Item2.3} | ${12:Item3.3} |\n${0}"
)

-- Insert table with 5 rows and 3 columns. First row is heading.
vimsnip.add(
  "5x3table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} |\n| --------------- | --------------- | --------------- |\n| ${4:Item1.1} | ${5:Item2.1} | ${6:Item3.1} |\n| ${7:Item1.2} | ${8:Item2.2} | ${9:Item3.2} |\n| ${10:Item1.3} | ${11:Item2.3} | ${12:Item3.3} |\n| ${13:Item1.4} | ${14:Item2.4} | ${15:Item3.4} |\n${0}"
)

-- Insert table with 2 rows and 4 columns. First row is heading.
vimsnip.add(
  "2x4table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} |\n| --------------- | --------------- | --------------- | --------------- |\n| ${5:Item1.1} | ${6:Item2.1} | ${7:Item3.1} | ${8:Item4.1} |\n${0}"
)

-- Insert table with 3 rows and 4 columns. First row is heading.
vimsnip.add(
  "3x4table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} |\n| --------------- | --------------- | --------------- | --------------- |\n| ${5:Item1.1} | ${6:Item2.1} | ${7:Item3.1} | ${8:Item4.1} |\n| ${9:Item1.2} | ${10:Item2.2} | ${11:Item3.2} | ${12:Item4.2} |\n${0}"
)

-- Insert table with 4 rows and 4 columns. First row is heading.
vimsnip.add(
  "4x4table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} |\n| --------------- | --------------- | --------------- | --------------- |\n| ${5:Item1.1} | ${6:Item2.1} | ${7:Item3.1} | ${8:Item4.1} |\n| ${9:Item1.2} | ${10:Item2.2} | ${11:Item3.2} | ${12:Item4.2} |\n| ${13:Item1.3} | ${14:Item2.3} | ${15:Item3.3} | ${16:Item4.3} |\n${0}"
)

-- Insert table with 5 rows and 4 columns. First row is heading.
vimsnip.add(
  "5x4table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} |\n| --------------- | --------------- | --------------- | --------------- |\n| ${5:Item1.1} | ${6:Item2.1} | ${7:Item3.1} | ${8:Item4.1} |\n| ${9:Item1.2} | ${10:Item2.2} | ${11:Item3.2} | ${12:Item4.2} |\n| ${13:Item1.3} | ${14:Item2.3} | ${15:Item3.3} | ${16:Item4.3} |\n| ${17:Item1.4} | ${18:Item2.4} | ${19:Item3.4} | ${20:Item4.4} |\n${0}"
)

-- Insert table with 2 rows and 5 columns. First row is heading.
vimsnip.add(
  "2x5table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} | ${5:Column5} |\n| --------------- | --------------- | --------------- | --------------- | --------------- |\n| ${6:Item1.1} | ${7:Item2.1} | ${8:Item3.1} | ${9:Item4.1} | ${10:Item5.1} |\n${0}"
)

-- Insert table with 3 rows and 5 columns. First row is heading.
vimsnip.add(
  "3x5table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} | ${5:Column5} |\n| --------------- | --------------- | --------------- | --------------- | --------------- |\n| ${6:Item1.1} | ${7:Item2.1} | ${8:Item3.1} | ${9:Item4.1} | ${10:Item5.1} |\n| ${11:Item1.2} | ${12:Item2.2} | ${13:Item3.2} | ${14:Item4.2} | ${15:Item5.2} |\n${0}"
)

-- Insert table with 4 rows and 5 columns. First row is heading.
vimsnip.add(
  "4x5table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} | ${5:Column5} |\n| --------------- | --------------- | --------------- | --------------- | --------------- |\n| ${6:Item1.1} | ${7:Item2.1} | ${8:Item3.1} | ${9:Item4.1} | ${10:Item5.1} |\n| ${11:Item1.2} | ${12:Item2.2} | ${13:Item3.2} | ${14:Item4.2} | ${15:Item5.2} |\n| ${16:Item1.3} | ${17:Item2.3} | ${18:Item3.3} | ${19:Item4.3} | ${20:Item5.3} |\n${0}"
)

-- Insert table with 5 rows and 5 columns. First row is heading.
vimsnip.add(
  "5x5table",
  "| ${1:Column1} | ${2:Column2} | ${3:Column3} | ${4:Column4} | ${5:Column5} |\n| --------------- | --------------- | --------------- | --------------- | --------------- |\n| ${6:Item1.1} | ${7:Item2.1} | ${8:Item3.1} | ${9:Item4.1} | ${10:Item5.1} |\n| ${11:Item1.2} | ${12:Item2.2} | ${13:Item3.2} | ${14:Item4.2} | ${15:Item5.2} |\n| ${16:Item1.3} | ${17:Item2.3} | ${18:Item3.3} | ${19:Item4.3} | ${20:Item5.3} |\n| ${21:Item1.4} | ${22:Item2.4} | ${23:Item3.4} | ${24:Item4.4} | ${25:Item5.4} |\n${0}"
)

-- Create a subscript.
vimsnip.add("sub", "${1}<sub>${0}")

-- Create a superscript.
vimsnip.add("sup", "${1}<sup>${0}")

-- Insert Note
vimsnip.add("note", "> [!NOTE]\n> ")
vimsnip.add("n", "> [!NOTE]\n> ")

-- Insert Tip
vimsnip.add("tip", "> [!TIP]\n> ")
vimsnip.add("t", "> [!TIP]\n> ")

-- Insert Important
vimsnip.add("important", "> [!IMPORTANT]\n> ")
vimsnip.add("imp", "> [!IMPORTANT]\n> ")

-- Insert Warning
vimsnip.add("warning", "> [!WARNING]\n> ")
vimsnip.add("w", "> [!WARNING]\n> ")

-- Insert Caution
vimsnip.add("caution", "> [!CAUTION]\n> ")
vimsnip.add("c", "> [!CAUTION]\n> ")
