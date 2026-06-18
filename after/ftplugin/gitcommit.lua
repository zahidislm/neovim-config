-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- conventional commit
  ["cc"] = "${1:type}(${2:scope}): ${3:title}\n\n$0",

  -- fix conventional commit
  ["fix"] = "fix(${1:scope}): ${2:title}\n\n$0",

  -- feat conventional commit
  ["feat"] = "feat(${1:scope}): ${2:title}\n\n$0",

  -- build conventional commit
  ["build"] = "build(${1:scope}): ${2:title}\n\n$0",

  -- chore conventional commit
  ["chore"] = "chore(${1:scope}): ${2:title}\n\n$0",

  -- ci conventional commit
  ["ci"] = "ci(${1:scope}): ${2:title}\n\n$0",

  -- docs conventional commit
  ["docs"] = "docs(${1:scope}): ${2:title}\n\n$0",

  -- style conventional commit
  ["style"] = "style(${1:scope}): ${2:title}\n\n$0",

  -- refactor conventional commit
  ["refactor"] = "refactor(${1:scope}): ${2:title}\n\n$0",

  -- perf conventional commit
  ["perf"] = "perf(${1:scope}): ${2:title}\n\n$0",

  -- test conventional commit
  ["test"] = "test(${1:scope}): ${2:title}\n\n$0",

  -- breaking change conventional commit footer
  ["BREAK"] = "BREAKING CHANGE: $0",

  -- co-authored by
  ["co"] = "Co-authored-by: ${1:name} <${2:email}>\n$0",

  -- signed off by
  ["si"] = "Signed-off-by: ${1:name} <${2:email}>\n$0",

  -- on behalf of
  ["on"] = "On-behalf-of: ${1:org} <${2:email}>\n$0",
})
