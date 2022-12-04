--- Trim newline at eof, trailing whitespace.
function _G.perform_cleanup()
    local patterns = {
        -- Remove leading empty lines
        [[%s/\%^\n//e]],
        -- Remove trailing empty lines
        [[%s/$\n\+\%$//e]],
        -- Remove trailing spaces
        [[%s/\s\+$//e]],
        -- Remove trailing "\r"
        [[%s/\r\+//e]],
    }

    local view = vim.fn.winsaveview()

    for _, v in pairs(patterns) do
        vim.cmd(string.format("keepjumps keeppatterns silent! %s", v))
    end

    vim.fn.winrestview(view)
end

--- Launch external program
--- @param prog string program to run
--- @vararg string args for program
function _G.launch_ext_prog(prog, ...)
    vim.fn.system(prog .. " " .. table.concat({ ... }, " "))
end

function _G.open_url(url, prefix)
    launch_ext_prog("start", (prefix or "") .. url)
end

-- Reloading lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
if pcall(require, "plenary") then
    local reload = require("plenary.reload").reload_module
    --- Reload module using plenary
    --- @param name string module
    function _G.plenary_reload(name)
        reload(name)
    end
end

--- Save and reload a module
function _G.save_reload_module()
    local file_path = vim.fn.fnameescape(vim.fn.expand("%:p"))

    -- Handle lowercase drive names
    file_path = file_path:gsub("^%l", string.upper)

    -- Handle weird behavior (multiple separators)
    if string.match(file_path, "\\\\") then
        file_path = file_path:gsub("\\\\", "\\")
    end

    -- Save changes if any
    vim.cmd("update!")

    if file_path:find("%.vim$") then
        -- Source
        vim.cmd(("source %s"):format(file_path))
        -- Print
        vim_notify(("%s Reloaded."):format(vim.fn.expand("%")), vim.log.levels.INFO)
    else
        -- Get module
        local module = get_module_name(file_path)
        -- Reload if current file is a valid module or is a ".vim" file
        if module then
            -- Reload
            plenary_reload(module)
            -- Source
            vim.cmd(("source %s"):format(file_path))
            -- Print
            vim_notify(("%s Reloaded."):format(module), vim.log.levels.INFO)
        end
    end
end

--- Quickfix toggle
--- https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
vim.api.nvim_create_user_command("QFix", function(bang)
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 and bang then
        vim.cmd("cclose")
    else
        vim.cmd("copen 10")
    end
end, {
    nargs = "?",
    bang = true,
    force = true,
})

--- Redraw before notifying
---@param msg string Content of the notification to show to the user.
---@param level number|nil One of the values from vim.log.levels.
function _G.vim_notify(msg, level)
    vim.cmd("redraw")
    vim.notify(msg, level)
end

function _G.exists_and_not_nil(t)
    if t then
        return next(t) ~= nil
    end
    return false
end

-- keymap helper
function _G.kmap(t)
    setmetatable(t,{__index={mode="n", opts={ silent = true }}})

    local mode, key, cmd, opts =
        t[1] or t.mode,
        t[2] or t.key,
        t[3] or t.cmd,
        t[4] or t.opts

    vim.keymap.set(mode, key, cmd, opts)
end
