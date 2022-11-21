return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
		_G.tailiscope_config = ext_config
	end,
	exports = {
		tailiscope = function()
			require("tailiscope")("base")
		end,
	},
})
