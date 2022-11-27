map("n", "tf", function()
    require("user.plugins.config.telescope.sources").git_or_find()
end, s_opts)

map("n", "tn", function()
    require("user.plugins.config.telescope.sources").dir_nvim()
end, s_opts)

map("n", "<F5>", function()
    require("user.plugins.config.telescope.sources").reload_modules()
end, s_opts)

map("n", "<F6>", function()
    require("user.plugins.config.telescope.sources").dir_plugins()
end, s_opts)
