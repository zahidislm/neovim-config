local lspconfig = require("lspconfig")
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local M = {}

local function setup_lsp_diagnostics(opts)
	vim.diagnostic.config(opts.diagnostics)

	vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
		local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
		pcall(vim.diagnostic.reset, ns)
		return true
	end

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

local function setup_lsp_capabilities()
	local lsp_defaults = lspconfig.util.default_config

	-- Code-folding w/ LSP
	lsp_defaults.capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- Combine LSP capabilities w/ cmp_nvim_lsp capabilities
	lsp_defaults.capabilities =
		vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
end

local function setup_lsp_attach()
	--setup on_attach
	require("utils").on_attach(function(client, buffer)
        require("plugins.lang-server.utils.formatting").setup(client, buffer)
		require("plugins.lang-server.keys").setup(client, buffer)
	end)
end

local function setup_lsp_servers(opts)
	local servers = opts.servers or {}
	-- Setup LSP Servers installed w/ Mason
	require("mason-lspconfig").setup_handlers({
		function(server)
			local default_flags = { flags = { debounce_text_changes = 250 } }
			local server_opts = servers[server] or {}
			server_opts = vim.tbl_deep_extend("force", server_opts, default_flags)

			require("lspconfig")[server].setup(server_opts)
		end,

		["rust_analyzer"] = function()
			require("rust-tools").setup({
				tools = { hover_actions = { auto_focus = true } },
				server = servers["rust_analyzer"] or {},
			})
		end,
	})
end

function M.setup(opts)
	-- setup LSP UI
	setup_lsp_diagnostics(opts)

	setup_lsp_capabilities()
	setup_lsp_attach()
	setup_lsp_servers(opts)
end

return M
