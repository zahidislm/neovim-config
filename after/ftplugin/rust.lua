-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------

vimsnip.add({
  -- #![allow(…)]
  ["allow"] = "#![allow(${1})]",

  -- #![deny(…)]
  ["deny"] = "#![deny(${1})]",

  -- #![warn(…)]
  ["warn"] = "#![warn(${1})]",

  -- #![no_std]
  ["no_std"] = "#![no_std]",

  -- #![no_core]
  ["no_core"] = "#![no_core]",

  -- #![feature(…)]
  ["feature"] = "#![feature(${1})]",

  -- #[macro_use(…)]
  ["macro_use"] = "#[macro_use(${1})]",

  -- #[repr(…)]
  ["repr"] = "#[repr(${1})]",

  -- #[cfg(…)]
  ["cfg"] = "#[cfg(${1})]",

  -- #[cfg_attr(…, …)]
  ["cfg_attr"] = "#[cfg_attr(${1}, ${2})]",

  -- cfg!(…)
  ["cfg!"] = "cfg!(${1})",

  -- column!()
  ["column"] = "column!()",

  -- concat!(…)
  ["concat"] = "concat!(${1})",

  -- concat_idents!(…)
  ["concat_idents"] = "concat_idents!(${1})",

  -- debug_assert!(…)
  ["debug_assert"] = "debug_assert!(${1});",

  -- debug_assert_eq!(…, …)
  ["debug_assert_eq"] = "debug_assert_eq!(${1}, ${2});",

  -- env!("…")
  ["env"] = 'env!("${1}")',

  -- file!()
  ["file"] = "file!()",

  -- format!(…)
  ["format"] = 'format!("${1}")',

  -- format_args!(…)
  ["format_args"] = 'format_args!("${1}")',

  -- include!("…");
  ["include"] = 'include!("${1}");',

  -- include_bytes!("…")
  ["include_bytes"] = 'include_bytes!("${1}")',

  -- include_str!("…")
  ["include_str"] = 'include_str!("${1}")',

  -- line!()
  ["line"] = "line!()",

  -- module_path!()
  ["module_path"] = "module_path!()",

  -- option_env!("…")
  ["option_env"] = 'option_env!("${1}")',

  -- panic!(…);
  ["panic"] = 'panic!("${1}");',

  -- print!(…);
  ["print"] = 'print!("${1}");',

  -- println!(…);
  ["println"] = 'println!("${1}");',

  -- stringify!(…)
  ["stringify"] = "stringify!(${1})",

  -- thread_local!(static …: … = …);
  ["thread_local"] = "thread_local!(static ${1:STATIC}: ${2:Type} = ${4:init});",

  -- try!(…)
  ["try"] = "try!(${1})",

  -- unimplemented!()
  ["unimplemented"] = "unimplemented!()",

  -- unreachable!(…)
  ["unreachable"] = "unreachable!(${1})",

  -- vec![…]
  ["vec"] = "vec![${1}]",

  -- write!(…)
  ["write"] = 'write!(${1}, "${2}")',

  -- writeln!(…, …)
  ["writeln"] = 'writeln!(${1}, "${2}")',

  -- assert!(…);
  ["assert"] = "assert!(${1});",

  -- assert_eq!(…, …);
  ["assert_eq"] = "assert_eq!(${1}, ${2});",

  -- #[bench]
  ["bench"] = "#[bench]\nfn ${1:name}(b: &mut test::Bencher) {\n    ${2:b.iter(|| ${3:/* benchmark code */})}\n}",

  -- const …: … = …;
  ["const"] = "const ${1:CONST}: ${2:Type} = ${4:init};",

  -- #[derive(…)]
  ["derive"] = "#[derive(${1})]",

  -- enum … { … }
  ["enum"] = "#[derive(Debug)]\nenum ${1:Name} {\n    ${2:Variant1},\n    ${3:Variant2},\n}",

  -- extern crate …;
  ["extern-crate"] = "extern crate ${1:name};",

  -- extern "C" fn …(…) { … }
  ["extern-fn"] = 'extern "C" fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:// add code here}\n}',

  -- extern "C" { … }
  ["extern-mod"] = 'extern "C" {\n    ${2:// add code here}\n}',

  -- pub fn …(…) { … }
  ["pfn"] = "pub fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}",

  -- fn …(…) { … }
  ["fn"] = "fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}",

  -- for … in … { … }
  ["for"] = "for ${1:pat} in ${2:expr} {\n    ${3:todo!();}\n}",

  -- if let … = … { … }
  ["if-let"] = "if let ${1:Some(pat)} = ${2:expr} {\n    ${0:todo!();}\n}",

  -- if … { … }
  ["if"] = "if ${1:condition} {\n    ${2:todo!();}\n}",

  -- impl … for … { … }
  ["impl-trait"] = "impl ${1:Trait} for ${2:Type} {\n    ${3:// add code here}\n}",

  -- inlined function
  ["inline-fn"] = "#[inline]\npub fn ${1:name}() {\n    ${2:todo!();}\n}",

  -- macro_rules! … { … }
  ["macro_rules"] = "macro_rules! ${1:name} {\n    (${2}) => (${3})\n}",

  -- fn main() { … }
  ["main"] = "fn main() {\n    ${1:todo!();}\n}",

  -- match … { … }
  ["match"] = "match ${1:expr} {}",

  -- mod … { … }
  ["mod-block"] = "mod ${1:name} {\n    ${2:// add code here}\n}",

  -- static …: … = …;
  ["static"] = "static ${1:STATIC}: ${2:Type} = ${4:init};",

  -- struct …(…);
  ["struct-tuple"] = "struct ${1:Name}(${2:Type});",

  -- struct …;
  ["struct-unit"] = "struct ${1:Name};",

  -- struct … { … }
  ["struct"] = "#[derive(Debug)]\nstruct ${1:Name} {\n    ${2:field}: ${3:Type}\n}",

  -- #[cfg(test)] mod test {...}
  ["modtest"] = "#[cfg(test)]\nmod test {\n    #[test]\n    fn ${1:name}() {\n        ${2:todo!();}\n    }\n}",

  -- #[test]
  ["test"] = "#[test]\nfn ${1:name}() {\n    ${2:todo!();}\n}",

  -- trait … { … }
  ["trait"] = "trait ${1:Name} {\n    ${2:// add code here}\n}\n",

  -- type … = …;
  ["type"] = "type ${1:Alias} = ${2:Type};",

  -- while let … = … { … }
  ["while-let"] = "while let ${1:Some(pat)} = ${2:expr} {\n    ${0:todo!();}\n}",

  -- while … { … }
  ["while"] = "while ${1:condition} {\n    ${2:todo!();}\n}",

  -- pub async fn …(…) { … }
  ["pafn"] = "pub async fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}",

  -- async fn …(…) { … }
  ["afn"] = "async fn ${1:name}(${2:arg}: ${3:Type}) -> ${4:RetType} {\n    ${5:todo!();}\n}",

  -- A Rust comment with description, parameters, returns, and examples.
  ["///"] = "/// ${1:Description.}$0\n///\n/// # Arguments\n///\n/// * ${3:`argument_name`} - ${4:type and description.}\n///\n/// # Returns\n/// ${2:type and description of the returned object.}\n///\n/// # Examples\n/// ```rust\n/// ${5:write me later}\n/// ```",

  -- A special Rust comment to describe a crate, with description and examples.
  ["//!"] = "//! ${1:Description.}$0\n//!\n//! # Examples\n//! ```rust\n//! ${2:write me later}\n//! ```",

  -- A Rust comment to describe a test, with description and examples.
  ["///test"] = "/// ${1:Description.}$0\n///\n/// # Examples\n/// ```rust\n/// ${2:write me later}\n/// ```",

  -- This form of the doc attribute lets you control the favicon of your docs.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(html_favicon_url)]"] = '#![doc(html_favicon_url = "${1:https://example.com/favicon.ico}$0")]',

  -- This form of the doc attribute lets you control the logo in the upper left hand side of the docs.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(html_logo_url)]"] = '#![doc(html_logo_url = "${1:https://example.com/logo.jpg}$0")]',

  -- This form of the doc attribute lets you control where the "run" buttons on your documentation examples make requests to.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(html_playground_url)]"] = '#![doc(html_playground_url = "${1:https://playground.example.com/}$0")]',

  -- This form of the doc attribute is mostly only useful for the standard library; When a feature is unstable, an issue number for tracking the feature must be given. rustdoc uses this number, plus the base URL given here, to link to the tracking issue.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(issue_tracker_base_url)]"] = '#![doc(issue_tracker_base_url = "${1:https://github.com/rust-lang/rust/issues/}$0")]',

  -- indicates the URL for generating links to external crates.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(html_root_url)]"] = '#![doc(html_root_url = "${1:https://docs.rs/serde/1.0}$0")]',

  -- By default, rustdoc will include the source code of your program, with links to it in the docs. But if you include this, it will not.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(html_no_source)]"] = "#![doc(html_no_source)]$0",

  -- By default, rustdoc will automatically add a line with extern crate my_crate; into each doctest.  But if you include this, it will not.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(test(no_crate_inject))]"] = "#![doc(test(no_crate_inject))]$0",

  -- This form of the doc attribute allows you to add arbitrary attributes to all your doctests. For example, if you want your doctests to fail if they produce any warnings, you could add this.  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![doc(test(attr(deny(warnings))))]"] = "#![doc(test(attr(deny(warnings))))]$0",

  -- These attribute is used on use statements, and control where the documentation shows up.  * How to use: You can use this on use statements. For example: `pub use bar::Bar;`
  ["#[doc(inline)]"] = "#[doc(inline)]$0",

  -- These attribute is used on use statements, and control where the documentation shows up.  * How to use: You can use this on use statements. For example: `pub use bar::Bar;`
  ["#[doc(no_inline)]"] = "#[doc(no_inline)]$0",

  -- Any item annotated with #[doc(hidden)] will not appear in the documentation, unless the strip-hidden pass is removed.  * How to use: You can use this on any item.
  ["#[doc(hidden)]"] = "#[doc(hidden)]$0",

  -- This feature allows you to add alias(es) to an item when using the rustdoc search through the doc(alias) attribute.  * How to use: You can use this on any item.
  ["#[doc(alias)]"] = '#[doc(alias = "${1:name}$0")]',

  -- How to report broken links when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::broken_intra_doc_links)]"] = "#![${1:warn}$0(rustdoc::broken_intra_doc_links)]",

  -- How to report when a public item is documented as private by mistake, or vice-versa, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::private_intra_doc_links)]"] = "#![${1:warn}$0(rustdoc::private_intra_doc_links)]",

  -- How to report when an item is missing comments, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(missing_docs)]"] = "#![${1:warn}$0(missing_docs)]",

  -- How to report when a crate is missing comments, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::missing_crate_level_docs)]"] = "#![${1:warn}$0(rustdoc::missing_crate_level_docs)]",

  -- How to report when a crate is missing examples, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::missing_doc_code_examples)]"] = "#![${1:warn}$0(rustdoc::missing_doc_code_examples)]",

  -- How to report documentation tests when they are on a private item, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: allow  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::private_doc_tests)]"] = "#![${1:warn}$0(rustdoc::private_doc_tests)]",

  -- How to report code block attributes in examples that have potentially mis-typed values, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::invalid_codeblock_attributes)]"] = "#![${1:warn}$0(rustdoc::invalid_codeblock_attributes)]",

  -- How to report unclosed or invalid HTML tags, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::invalid_html_tags)]"] = "#![${1:warn}$0(rustdoc::invalid_html_tags)]",

  -- How to report code blocks in examples that are invalid, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::invalid_rust_codeblocks)]"] = "#![${1:warn}$0(rustdoc::invalid_rust_codeblocks)]",

  -- How to report URLs which are not links, when generating the documentation.  * Accepted vales: allow, warn, deny.  * Default: warn  * How to use: This lint option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#![warn(rustdoc::bare_urls)]"] = "#![${1:warn}$0(rustdoc::bare_urls)]",

  -- Documents the item can only be used on Unix.  * Accepted vales: unix, windows  * How to use: This style option must be added at the top of the src/lib.rs or main.rs file in your binary project.
  ["#[cfg()]"] = "#[cfg(any(${1:unix}$0, doc))",
})
