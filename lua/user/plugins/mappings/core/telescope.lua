map("n", "tf", function()
    require(P_CONFIGS .. "core.telescope.sources").git_or_find()
end, s_opts)

map("n", "tn", function()
    require(P_CONFIGS .. "core.telescope.sources").dir_nvim()
end, s_opts)

map("n", "<F5>", function()
    require(P_CONFIGS .. "core.telescope.sources").reload_modules()
end, s_opts)

map("n", "<F6>", function()
    require(P_CONFIGS .. "core.telescope.sources").dir_plugins()
end, s_opts)
