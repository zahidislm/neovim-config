local modules = {
	"ai",
	"bracketed",
	"comment",
	"indentscope",
	"move",
	"surround",
}

local function init_mini(conf)
	conf = conf or {}
	local spec = {}

	for mod = 1, #modules do
		local configuration = conf[modules[mod]] or {}

		local mod_url = "echasnovski/mini." .. modules[mod]
		local mod_dependencies = configuration["dependencies"] or nil
		local mod_opts = configuration["opts"] or {}
		local mod_init = configuration["init"] or nil
		local mod_event = configuration["event"] or "VeryLazy"
		local mod_keys = configuration["keys"] or nil

		local mod_spec = {
			mod_url,
			dependencies = mod_dependencies,
			opts = mod_opts,
			init = mod_init,
			keys = mod_keys,
		}

		if not mod_keys then
			mod_spec["event"] = mod_event
		end

		spec[#spec + 1] = mod_spec
	end

	return spec
end

return init_mini(require("plugins.mini.config"))
