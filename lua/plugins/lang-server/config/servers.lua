local M = {}
local path = "plugins.lang-server."

function M.on_attach(client, bufnr)
	require(path .. "formatting").setup(client, bufnr)
	require(path .. "keys").setup(client, bufnr)
end

function M.setup()
	-- Setup LSP Servers installed w/ Mason
	require("mason-lspconfig").setup_handlers({
		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({
				on_attach = M.on_attach,
				flags = {
					debounce_text_changes = 150,
				},
			})
		end,

		["rust_analyzer"] = function()
			require("lspconfig")["rust_analyzer"].setup({
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = {
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
					},
				},

				on_attach = M.on_attach,
			})
		end,

		["sumneko_lua"] = function()
			require("lspconfig")["sumneko_lua"].setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
								"PARSERS",
								"SERVERS",
								"FORMATTERS",
							},
						},
					},
				},

				on_attach = M.on_attach,
				flags = {
					debounce_text_changes = 150,
				},
			})
		end,
	})
end

return M
