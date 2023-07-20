return {
	{
		"ibhagwan/fzf-lua",
		name = "fzf",
		opts = function()
			return require("plugins.fzf.config")
		end,
		config = function(_, opts)
			local fzf = require("fzf-lua")
			fzf.setup(opts)
			fzf.register_ui_select(function(_, items)
				local min_h, max_h = 0.15, 0.70
				local h = (#items + 4) / vim.o.lines
				if h < min_h then
					h = min_h
				elseif h > max_h then
					h = max_h
				end
				return { winopts = { height = h, width = 0.5, row = 0.45 } }
			end)
		end,
		keys = function()
			return require("plugins.fzf.keys").setup()
		end,
	},

	{
		"gennaro-tedesco/nvim-possession",
		dependencies = { "fzf" },
		opts = {
			autoswitch = { enabled = true },
			save_hook = function()
				-- Get visible buffers
				local visible_buffers = {}
				local windows = vim.api.nvim_list_wins()
				for win = 1, #windows do
					visible_buffers[vim.api.nvim_win_get_buf(windows[win])] = true
				end

				local buflist = vim.api.nvim_list_bufs()
				for bufnr = 1, #buflist do
					if visible_buffers[buflist[bufnr]] == nil then -- Delete buffer if not visible
						vim.cmd("bd " .. buflist[bufnr])
					end
				end
			end,
			fzf_winopts = {
				width = 0.5,
				row = 0.45,
			},
		},
		keys = function()
			return require("plugins.fzf.keys").setup("possession")
		end,
	},
}
