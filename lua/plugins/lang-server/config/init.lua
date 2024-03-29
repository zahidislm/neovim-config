local lspconfig = require("lspconfig")
local M = {}
local icons = vim.g.ui_icons

local function setup_lsp_diagnostics(opts)
	vim.diagnostic.config(opts)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = icons.misc.border,
	})

	vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
		local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
		pcall(vim.diagnostic.reset, ns)
		return true
	end

	for type, icon in pairs(icons.diagnostics) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

local function setup_lsp_capabilities(opts)
	local default_capabilities = vim.lsp.protocol.make_client_capabilities()
	local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

	-- Combine LSP capabilities w/ cmp_nvim_lsp capabilities & user options
	local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		default_capabilities,
		has_cmp and cmp_nvim_lsp.default_capabilities() or {},
		opts
	)

	return capabilities
end

local function setup_lsp_attach()
	--setup on_attach
	require("utils").on_attach(function(client, buffer)
		require("plugins.lang-server.keys").setup(client, buffer)
	end)
end

local function setup_lsp_servers(server_configs, capability_opts)
	-- Setup LSP Servers installed w/ Mason
	require("mason-lspconfig").setup_handlers({
		function(server)
			local default_flags = { flags = { debounce_text_changes = 250 } }
			local capabilities = setup_lsp_capabilities(capability_opts)
			local user_opts = server_configs[server] or {}
			local server_opts = vim.tbl_deep_extend("force", { vim.deepcopy(capabilities) }, default_flags, user_opts)

			lspconfig[server].setup(server_opts)
		end,
	})
end

function M.setup(opts)
	opts = type(opts) == "table" and opts or {}
	local diag_opts = opts.diagnostics or {}
	local servers_opts = opts.servers or {}
	local capability_opts = opts.capabilities or {}

	setup_lsp_diagnostics(diag_opts)
	setup_lsp_attach()
	setup_lsp_servers(servers_opts, capability_opts)
end

return M
