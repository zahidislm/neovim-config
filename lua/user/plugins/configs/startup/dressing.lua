require('dressing').setup({
	select = {
		get_config = function(opts)
			opts = opts or {}
			local cfg = {
				telescope = {
					layout_config = {
						width = 80,
						height = 15,
					},
				},
			}

			if opts.kind == 'legendary.nvim' then
				cfg.telescope.sorter = require('telescope.sorters').fuzzy_with_index_bias({})
			end

			return cfg
		end,
	},
})
