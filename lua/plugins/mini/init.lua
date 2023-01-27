local modules = {
	"ai",
	"comment",
	"cursorword",
	"indentscope",
	"move",
	"pairs",
	"sessions",
	"surround",
}

local function init_mini(conf)
	conf = conf or {}
	local spec = {}

	for pos, mod in ipairs(modules) do
		local mod_url = "echasnovski/mini." .. mod
		local configuration = conf[mod] or {}
		local mod_version = "*"

		if configuration["version"] ~= nil then
			mod_version = configuration["version"]
		end

		local mod_keys = configuration["keys"] or nil
		local mod_event = configuration["event"] or "BufReadPost"
		local mod_dependencies = configuration["dependencies"] or nil
		local mod_opts = configuration["opts"] or {}
		local mod_config = function(_, opts)
			require("mini." .. mod).setup(opts)
		end

		local mod_spec = {
			mod_url,
			version = mod_version,
			event = mod_event,
			keys = mod_keys,
			dependencies = mod_dependencies,
			opts = mod_opts,
			config = mod_config,
		}

		table.insert(spec, pos, mod_spec)
	end

	return spec
end

return init_mini(require("plugins.mini.config"))
