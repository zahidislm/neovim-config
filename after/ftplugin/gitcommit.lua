-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- conventional commit
vimsnip.add("cc", "${1:type}(${2:scope}): ${3:title}\n\n$0")

-- fix conventional commit
vimsnip.add("fix", "fix(${1:scope}): ${2:title}\n\n$0")

-- feat conventional commit
vimsnip.add("feat", "feat(${1:scope}): ${2:title}\n\n$0")

-- build conventional commit
vimsnip.add("build", "build(${1:scope}): ${2:title}\n\n$0")

-- chore conventional commit
vimsnip.add("chore", "chore(${1:scope}): ${2:title}\n\n$0")

-- ci conventional commit
vimsnip.add("ci", "ci(${1:scope}): ${2:title}\n\n$0")

-- docs conventional commit
vimsnip.add("docs", "docs(${1:scope}): ${2:title}\n\n$0")

-- style conventional commit
vimsnip.add("style", "style(${1:scope}): ${2:title}\n\n$0")

-- refactor conventional commit
vimsnip.add("refactor", "refactor(${1:scope}): ${2:title}\n\n$0")

-- perf conventional commit
vimsnip.add("perf", "perf(${1:scope}): ${2:title}\n\n$0")

-- test conventional commit
vimsnip.add("test", "test(${1:scope}): ${2:title}\n\n$0")

-- breaking change conventional commit footer
vimsnip.add("BREAK", "BREAKING CHANGE: $0")

-- co-authored by
vimsnip.add("co", "Co-authored-by: ${1:name} <${2:email}>\n$0")

-- signed off by
vimsnip.add("si", "Signed-off-by: ${1:name} <${2:email}>\n$0")

-- on behalf of
vimsnip.add("on", "On-behalf-of: ${1:org} <${2:email}>\n$0")
