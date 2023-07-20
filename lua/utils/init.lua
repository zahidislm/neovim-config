local M = {}
local terminals = {}

-- run shell command and get output lines as lua table
-- from: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
local function lua_systemlist(cmd)
	local stdout, rc = {}, nil
	local handle = io.popen(cmd .. " 2>&1 ; echo $?", "r")

	if handle then
		for line in handle:lines() do
			stdout[#stdout + 1] = line
		end
		rc = tonumber(stdout[#stdout])
		stdout[#stdout] = nil
		handle:close()
	end

	return stdout, rc
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		ft = "lazyterm",
		size = { width = 0.66, height = 0.66 },
		border = "solid",
	}, opts or {}, { persistent = true })

	local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

	if terminals[termkey] and terminals[termkey]:buf_valid() then
		terminals[termkey]:toggle()
	else
		terminals[termkey] = require("lazy.util").float_term(cmd, opts)
		local buf = terminals[termkey].buf

		vim.b[buf].lazyterm_cmd = cmd
		vim.keymap.set("t", "<C-q>", "<C-\\><c-n>:q!<CR>", { desc = "Exit terminal", buffer = buf, nowait = true })

		vim.api.nvim_create_autocmd("BufEnter", {
			buffer = buf,
			callback = function()
				vim.cmd.startinsert()
			end,
		})
	end

	return terminals[termkey]
end

-- Keymap helper
function M.keymap(mode, lhs, rhs, opts)
	opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

	vim.keymap.set(mode, lhs, rhs, opts)
end

-- run shell command and get str output
function M.lua_system(cmd)
	local stdout, rc = lua_systemlist(cmd)
	if next(stdout) == nil then
		return nil, rc
	end
	return table.concat(stdout, "\n"), rc
end

-- get which python3 in current env
-- NOTE(vir): assuming python3 exists on all systems
function M.get_python()
	local python, _ = M.lua_system("which python3")
	return python
end

return M
