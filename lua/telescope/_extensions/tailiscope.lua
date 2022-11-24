local tailiscope = require("tailiscope")

local openPicker = function(picker, opts)
	opts = opts or {}
	opts = vim.tbl_deep_extend("force", tailiscope.config, opts)
	tailiscope.picker(picker, opts)
end

return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config

		tailiscope.config = vim.tbl_deep_extend("force", tailiscope.config, config)
		tailiscope.config = vim.tbl_deep_extend("force", tailiscope.config, ext_config)
	end,
	-- Should I clear history here?
	exports = {
		tailiscope = function(opts)
			-- tailiscope.history = {}
			openPicker(tailiscope.config.default, opts)
		end,
		base = function(opts)
			openPicker("base", opts)
		end,
		categories = function(opts)
			openPicker("categories", opts)
		end,
		classes = function(opts)
			openPicker("classes", opts)
		end,
		all = function(opts)
			openPicker("all", opts)
		end,
	},
})
