local mapgrp = require("legendary").itemgroups

-- ------------------------------ CORE Telescope ----------------------------- --
local builtin_ts_mappings = {
	{ "to", ":Telescope<CR>", description = "Opens Telescope picker window" },
	{ "fb", ":Telescope file_browser<CR>", description = "Opens file browser" },
	{ "tt", ":Telescope buffers<CR>", description = "Lists open buffers" },
	{ "<S-Tab>", ":bp<CR>", description = "Quickly jumps to prev buffer." },
	{ "tg", ":Telescope live_grep<CR>", description = "Greps within current working dir" },
	{ "ts", ":Telescope git_status<CR>", description = "Gets git status for all files in scope" }
}

-- ------------------------------ Telescope Utilities ----------------------------- --
local utility_ts_mappings = {
	{
		"tf", function() require(P_CONFIGS .. "startup.telescope.sources").git_or_find() end,
		description = "Fall back to find_files if not a git directory"
	},
	{
		"tn", function() require(P_CONFIGS .. "startup.telescope.sources").dir_nvim() end,
		description = "List NVIM CONFIG directories"
	},
}

mapgrp({
	{
		itemgroup = "TELESCOPE BUILTINS",
		keymaps = builtin_ts_mappings,
		description = "Mappings to activate Telescope pickers",
		icon = ""
	},
	{
		itemgroup = "TELESCOPE UTILITIES",
		keymaps = utility_ts_mappings,
		description = "Mappings to activate Telescope utility functions",
		icon = ""
	},
})
