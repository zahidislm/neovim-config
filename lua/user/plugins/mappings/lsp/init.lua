local M = {}
local mapgrp = require("legendary").itemgroups
local toolbox = require("legendary.toolbox")

M.init = function(b_opts)
	-- Native LSP mappings
	local lsp_mappings = {
		{
			"gD",
			":lua vim.lsp.buf.declaration()<CR>",
			description = "Shows declaration of the word under the cursor",
			opts = b_opts,
		},
		{
			"ca",
			":lua vim.lsp.buf.code_action()<CR>",
			description = "Lists any LSP actions for the word under the cursor",
			opts = b_opts,
		},
		{
			"K",
			-- ":lua vim.lsp.buf.hover()<CR>",
			function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end,
			description = "Shows LSP signature on hover",
			opts = b_opts,
		},
		{
			"[g",
			":lua vim.lsp.diagnostic.goto_prev()<CR>",
			description = "Jump to previous diagnostic",
			opts = b_opts,
		},
		{
			"]g",
			":lua vim.lsp.diagnostic.goto_next()<CR>",
			description = "Jump to next diagnostic",
			opts = b_opts,
		},
		{
			"rn",
			":lua vim.lsp.buf.rename()<CR>",
			description = "Renames the LSP object for the word under the cursor",
			opts = b_opts,
		},
	}
	-- Telescope + LSP mappings
	local lsp_ts_mappings = {
		{
			"gd",
			":Telescope lsp_definitions<CR>",
			description = "Jumps to the definition of the word under the cursor",
			opts = b_opts,
		},
		{
			"gr",
			":Telescope lsp_references<CR>",
			description = "Lists LSP references for word under the cursor",
			opts = b_opts,
		},
		{
			"gi",
			":Telescope lsp_implementations",
			description = "Jumps to the implementation of the word under the cursor",
			opts = b_opts,
		},
		{
			"gs",
			":Telescope lsp_document_symbols<CR>",
			description = "Toggles LSP Symbol View in the current buffer",
			opts = b_opts,
		},
		{
			"gt",
			":Telescope diagnostics<CR>",
			description = "Lists LSP diagnostic & lint errors for workspace",
			opts = b_opts,
		},
		{
			"glt",
			toolbox.lazy_required_fn("telescope.builtin", "diagnostics", { bufnr = 0 }),
			description = "Lists LSP diagnostic & lint errors for workspace",
			opts = b_opts,
		},
	}

	mapgrp({
		{
			itemgroup = "NEOVIM LSP",
			keymaps = lsp_mappings,
			description = "Diagnostics & Helper mappings for LSP clients",
			icon = "",
		},
		{
			itemgroup = "TELESCOPE LSP",
			keymaps = lsp_ts_mappings,
			description = "LSP client mappings that utilize Telescope pickers",
			icon = "",
		},
	})
end

return M
