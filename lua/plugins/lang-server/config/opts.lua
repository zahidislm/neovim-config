return {
	diagnostics = {
		underline = true,
		update_in_insert = false,
		virtual_text = { spacing = 2, prefix = "" },
		severity_sort = true,
	},

	servers = {
		lua_ls = {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					completion = {
						workspaceWord = true,
						callSnippet = "Both",
					},
					diagnostics = { globals = { "vim" } },
					format = { enable = false },
				},
			},
		},

		jedi_language_server = {
			init_options = {
				diagnostics = { enable = false },
			},
			jediSettings = {
				autoImportModules = { "numpy", "torch" },
			},
		},

		rust_analyzer = {
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
					checkOnSave = {
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
				},
			},
		},
	},
}
