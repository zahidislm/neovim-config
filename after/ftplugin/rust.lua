-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

-- #![allow(…)]
vimsnip.add("allow", "#![allow(${1})]")

-- #![deny(…)]
vimsnip.add("deny", "#![deny(${1})]")

-- #![warn(…)]
vimsnip.add("warn", "#![warn(${1})]")

-- #![no_std]
vimsnip.add("no_std", "#![no_std]")

-- #![no_core]
vimsnip.add("no_core", "#![no_core]")

-- #![feature(…)]
vimsnip.add("feature", "#![feature(${1})]")

-- #[macro_use(…)]
vimsnip.add("macro_use", "#[macro_use(${1})]")

-- #[repr(…)]
vimsnip.add("repr", "#[repr(${1})]")

-- #[cfg(…)]
vimsnip.add("cfg", "#[cfg(${1})]")

-- #[cfg_attr(…, …)]
vimsnip.add("cfg_attr", "#[cfg_attr(${1}, ${2})]")

-- cfg!(…)
vimsnip.add("cfg!", "cfg!(${1})")

-- column!()
vimsnip.add("column", "column!()")

-- concat!(…)
vimsnip.add("concat", "concat!(${1})")

-- concat_idents!(…)
vimsnip.add("concat_idents", "concat_idents!(${1})")

-- debug_assert!(…)
vimsnip.add("debug_assert", "debug_assert!(${1});")

-- debug_assert_eq!(…, …)
vimsnip.add("debug_assert_eq", "debug_assert_eq!(${1}, ${2});")

-- env!("…")
vimsnip.add("env", 'env!("${1}")')

-- file!()
vimsnip.add("file", "file!()")

-- format!(…)
vimsnip.add("format", 'format!("${1}")')

-- format_args!(…)
vimsnip.add("format_args", 'format_args!("${1}")')

-- include!("…");
vimsnip.add("include", 'include!("${1}");')

-- include_bytes!("…")
vimsnip.add("include_bytes", 'include_bytes!("${1}")')

-- include_str!("…")
vimsnip.add("include_str", 'include_str!("${1}")')

-- line!()
vimsnip.add("line", "line!()")

-- module_path!()
vimsnip.add("module_path", "module_path!()")

-- option_env!("…")
vimsnip.add("option_env", 'option_env!("${1}")')

-- panic!(…);
vimsnip.add("panic", 'panic!("${1}");')

-- print!(…);
vimsnip.add("print", 'print!("${1}");')

-- println!(…);
vimsnip.add("println", 'println!("${1}");')

-- stringify!(…)
vimsnip.add("stringify", "stringify!(${1})")

-- thread_local!(static …: … = …);
vimsnip.add("thread_local", "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});")

-- try!(…)
vimsnip.add("try", "try!(${1})")

-- unimplemented!()
vimsnip.add("unimplemented", "unimplemented!()")

-- unreachable!(…)
vimsnip.add("unreachable", "unreachable!(${1})")

-- vec![…]
vimsnip.add("vec", "vec![${1}]")

-- write!(…)
vimsnip.add("write", 'write!(${1}, "${2}")')

-- writeln!(…, …)
vimsnip.add("writeln", 'writeln!(${1}, "${2}")')

-- assert!(…);
vimsnip.add("assert", "assert!(${1});")

-- assert_eq!(…, …);
vimsnip.add("assert_eq", "assert_eq!(${1}, ${2});")

-- #[bench]
vimsnip.add(
  "bench",
  "#[bench]\nfn ${1:name}(b: &mut test::Bencher) {\n    ${2:b.iter(|| ${3:/* benchmark code */})}\n}"
)

-- const …: … = …;
vimsnip.add("const", "const ${1:CONST}: ${2:Type} = ${4:init};")

-- #[derive(…)]
vimsnip.add("derive", "#[derive(${1})]")

-- enum … { … }
vimsnip.add(
  "enum", "#[derive(Debug)]\nenum ${1:Name} {\n    ${2:Variant1},\n    ${3:Variant2},\n}"
)

-- extern crate …;
vimsnip.add("extern-crate", "extern crate ${1:name};")

-- extern "C" fn …(…) { … }
vimsnip.add(
  "extern-fn",
  'extern "C" fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:// add code here}\n}'
)

-- extern "C" { … }
vimsnip.add("extern-mod", 'extern "C" {\n    ${2:// add code here}\n}')

-- pub fn …(…) { … }
vimsnip.add(
  "pfn", "pub fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}"
)

-- fn …(…) { … }
vimsnip.add("fn", "fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}")

-- for … in … { … }
vimsnip.add("for", "for ${1:pat} in ${2:expr} {\n    ${3:todo!();}\n}")

-- if let … = … { … }
vimsnip.add("if-let", "if let ${1:Some(pat)} = ${2:expr} {\n    ${0:todo!();}\n}")

-- if … { … }
vimsnip.add("if", "if ${1:condition} {\n    ${2:todo!();}\n}")

-- impl … for … { … }
vimsnip.add("impl-trait", "impl ${1:Trait} for ${2:Type} {\n    ${3:// add code here}\n}")

-- inlined function
vimsnip.add("inline-fn", "#[inline]\npub fn ${1:name}() {\n    ${2:todo!();}\n}")

-- macro_rules! … { … }
vimsnip.add("macro_rules", "macro_rules! ${1:name} {\n    (${2}) => (${3})\n}")

-- fn main() { … }
vimsnip.add("main", "fn main() {\n    ${1:todo!();}\n}")

-- match … { … }
vimsnip.add("match", "match ${1:expr} {}")

-- mod … { … }
vimsnip.add("mod-block", "mod ${1:name} {\n    ${2:// add code here}\n}")

-- static …: … = …;
vimsnip.add("static", "static ${1:STATIC}: ${2:Type} = ${4:init};")

-- struct …(…);
vimsnip.add("struct-tuple", "struct ${1:Name}(${2:Type});")

-- struct …;
vimsnip.add("struct-unit", "struct ${1:Name};")

-- struct … { … }
vimsnip.add("struct", "#[derive(Debug)]\nstruct ${1:Name} {\n    ${2:field}: ${3:Type}\n}")

-- #[cfg(test)] mod test {...}
vimsnip.add(
  "modtest",
  "#[cfg(test)]\nmod test {\n    #[test]\n    fn ${1:name}() {\n        ${2:todo!();}\n    }\n}"
)

-- #[test]
vimsnip.add("test", "#[test]\nfn ${1:name}() {\n    ${2:todo!();}\n}")

-- trait … { … }
vimsnip.add("trait", "trait ${1:Name} {\n    ${2:// add code here}\n}\n")

-- type … = …;
vimsnip.add("type", "type ${1:Alias} = ${2:Type};")

-- while let … = … { … }
vimsnip.add("while-let", "while let ${1:Some(pat)} = ${2:expr} {\n    ${0:todo!();}\n}")

-- while … { … }
vimsnip.add("while", "while ${1:condition} {\n    ${2:todo!();}\n}")

-- pub async fn …(…) { … }
vimsnip.add(
  "pafn", "pub async fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}"
)

-- async fn …(…) { … }
vimsnip.add(
  "afn", "async fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}"
)

-- A Rust comment with description, parameters, returns, and examples.
vimsnip.add(
  "///",
  "/// ${1:Description.}$0\n///\n/// # Arguments\n///\n/// * ${3:`argument_name`} - ${4:type and description.}\n///\n/// # Returns\n/// ${2:type and description of the returned object.}\n///\n/// # Examples\n/// ```rust\n/// ${5:write me later}\n/// ```"
)

-- A special Rust comment to describe a crate, with description and examples.
vimsnip.add(
  "//!",
  "//! ${1:Description.}$0\n//!\n//! # Examples\n//! ```rust\n//! ${2:write me later}\n//! ```"
)

-- A Rust comment to describe a test, with description and examples.
vimsnip.add(
  "///test",
  "/// ${1:Description.}$0\n///\n/// # Examples\n/// ```rust\n/// ${2:write me later}\n/// ```"
)

-- This form of the doc attribute lets you control the favicon of your docs.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![doc(html_favicon_url)]",
  '#![doc(html_favicon_url = "${1:https://example.com/favicon.ico}$0")]'
)

-- This form of the doc attribute lets you control the logo in the upper left hand side of the docs.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![doc(html_logo_url)]", '#![doc(html_logo_url = "${1:https://example.com/logo.jpg}$0")]'
)

-- This form of the doc attribute lets you control where the "run" buttons on your documentation examples make requests to.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![doc(html_playground_url)]",
  '#![doc(html_playground_url = "${1:https://playground.example.com/}$0")]'
)

-- This form of the doc attribute is mostly only useful for the standard library; When a feature is unstable, an issue number for tracking the feature must be given. rustdoc uses this number, plus the base URL given here, to link to the tracking issue.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![doc(issue_tracker_base_url)]",
  '#![doc(issue_tracker_base_url = "${1:https://github.com/rust-lang/rust/issues/}$0")]'
)

-- indicates the URL for generating links to external crates.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![doc(html_root_url)]", '#![doc(html_root_url = "${1:https://docs.rs/serde/1.0}$0")]'
)

-- By default, rustdoc will include the source code of your program, with links to it in the docs. But if you include this, it will not.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#![doc(html_no_source)]", "#![doc(html_no_source)]$0")

-- By default, rustdoc will automatically add a line with extern crate my_crate; into each doctest.  But if you include this, it will not.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#![doc(test(no_crate_inject))]", "#![doc(test(no_crate_inject))]$0")

-- This form of the doc attribute allows you to add arbitrary attributes to all your doctests. For example, if you want your doctests to fail if they produce any warnings, you could add this.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#![doc(test(attr(deny(warnings))))]", "#![doc(test(attr(deny(warnings))))]$0")

-- These attribute is used on use statements, and control where the documentation shows up.  * How to use: You can use this on use statements. For example: `pub use bar::Bar;`
vimsnip.add("#[doc(inline)]", "#[doc(inline)]$0")

-- These attribute is used on use statements, and control where the documentation shows up.  * How to use: You can use this on use statements. For example: `pub use bar::Bar;`
vimsnip.add("#[doc(no_inline)]", "#[doc(no_inline)]$0")

-- Any item annotated with #[doc(hidden)] will not appear in the documentation, unless the strip-hidden pass is removed.  * How to use: You can use this on any item.
vimsnip.add("#[doc(hidden)]", "#[doc(hidden)]$0")

-- This feature allows you to add alias(es) to an item when using the rustdoc search through the doc(alias) attribute.  * How to use: You can use this on any item.
vimsnip.add("#[doc(alias)]", '#[doc(alias = "${1:name}$0")]')

-- How to report broken links when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::broken_intra_doc_links)]", "#![${1:warn}$0(rustdoc::broken_intra_doc_links)]"
)

-- How to report when a public item is documented as private by mistake, or vice-versa, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::private_intra_doc_links)]", "#![${1:warn}$0(rustdoc::private_intra_doc_links)]"
)

-- How to report when an item is missing comments, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#![warn(missing_docs)]", "#![${1:warn}$0(missing_docs)]")

-- How to report when a crate is missing comments, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::missing_crate_level_docs)]",
  "#![${1:warn}$0(rustdoc::missing_crate_level_docs)]"
)

-- How to report when a crate is missing examples, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::missing_doc_code_examples)]",
  "#![${1:warn}$0(rustdoc::missing_doc_code_examples)]"
)

-- How to report documentation tests when they are on a private item, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::private_doc_tests)]", "#![${1:warn}$0(rustdoc::private_doc_tests)]"
)

-- How to report code block attributes in examples that have potentially mis-typed values, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::invalid_codeblock_attributes)]",
  "#![${1:warn}$0(rustdoc::invalid_codeblock_attributes)]"
)

-- How to report unclosed or invalid HTML tags, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::invalid_html_tags)]", "#![${1:warn}$0(rustdoc::invalid_html_tags)]"
)

-- How to report code blocks in examples that are invalid, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add(
  "#![warn(rustdoc::invalid_rust_codeblocks)]", "#![${1:warn}$0(rustdoc::invalid_rust_codeblocks)]"
)

-- How to report URLs which are not links, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#![warn(rustdoc::bare_urls)]", "#![${1:warn}$0(rustdoc::bare_urls)]")

-- Documents the item can only be used on Unix.  * Accepted vales: unix, windows  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
vimsnip.add("#[cfg()]", "#[cfg(any(${1:unix}$0, doc))")
