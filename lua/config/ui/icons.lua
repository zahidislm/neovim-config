_G.ICONS = {
	listchars = {
		lead = "·",
		trail = "•",
		extends = "❯",
		precedes = "❮",
		nbsp = "␣",
	},

	diagnostics = {
		Error = " ",
		Warn = " ",
		Info = " ",
		Hint = " ",
		Debug = " ",
		Trace = " ",
	},

	dap = {
		breakpoint = " ",
		breakpoint_condition = " ",
		log_point = " ",
		stopped = " ",
		breakpoint_rejected = " ",
		pause = " ",
		play = " ",
		step_into = " ",
		step_over = " ",
		step_out = " ",
		step_back = " ",
		run_last = " ",
		terminate = " ",
	},

	git = {
		status_added = " ",
		status_removed = " ",
		status_modified = " ",
		added = " ",
		deleted = " ",
		modified = " ",
		renamed = " ",
		untracked = " ",
		ignored = " ",
		unstaged = " ",
		staged = " ",
		conflict = " ",
	},

	misc = {
		collapsed = " ",
		expanded = " ",
		condense = "󰡍 ",
		v_border = "│ ",
		select = " ",
		prompt = " ",
		next_line = "󰌑 ",
	},
}

vim.opt.listchars:append(ICONS.listchars)
