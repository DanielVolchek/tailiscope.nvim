local opts = {}
local tailiscope = require("tailiscope")

return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
		tailiscope.config = vim.tbl_deep_extend("force", M.config, ext_config)
		opts = config
	end,
	exports = {
		tailiscope = function()
			tailiscope.picker(tailiscope.config.default, opts)
		end,
		categories = function()
			tailiscope.picker("categories", opts)
		end,
		classes = function()
			tailiscope.picker("classes", opts)
		end,
		all = function()
			tailiscope.picker("all", opts)
		end,
	},
})
