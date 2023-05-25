return {
	-- default replacements
	{ "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
	{ "Y", mode = { "n", "x" } },
	{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
	{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
	{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
	{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },

	-- Paste after/before line
	{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Paste after cursorline" },
	{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Paste before cursorline" },

	-- paste w/ re-indent
	{ "=p", "<Plug>(YankyPutAfterFilter)" },
	{ "=P", "<Plug>(YankyPutBeforeFilter)" },

	-- Yank Ring
	{ "<C-n>", "<Plug>(YankyCycleForward)", desc = "Cycle clipboard foward" },
	{ "<C-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle clipboard backward" },
}
