-- Open main Telescope window
kmap{key="to", cmd="<cmd>Telescope<CR>"}

-- Opens file browser
kmap{key="fb", cmd="<cmd>Telescope file_browser<CR>"}

-- Greps within current working dir
kmap{key="tg", cmd="<cmd>Telescope live_grep<CR>"}

-- Gets git status for all files in scope
kmap{key="ts", cmd="<cmd>Telescope git_status<CR>"}

-- Telescope utilities
kmap{key="tf", cmd=function()
    require(P_CONFIGS .. "startup.telescope.sources").git_or_find()
end}

kmap{key="tn", cmd=function()
    require(P_CONFIGS .. "startup.telescope.sources").dir_nvim()
end}

kmap{key="<F5>", cmd=function()
    require(P_CONFIGS .. "startup.telescope.sources").reload_modules()
end}

kmap{key="<F6>", cmd=function()
    require(P_CONFIGS .. "startup.telescope.sources").dir_plugins()
end}
