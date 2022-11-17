return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
		vim.notify("ext_config is ")
		vim.notify(vim.inspect(ext_config))
	end,
	exports = {
		tailiscope = require("tailiscope")(),
	},
})
