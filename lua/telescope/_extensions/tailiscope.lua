local opts = {}

return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
		require("tailiscope").config = vim.tbl_deep_extend("force", M.config, ext_config)
		opts = config
	end,
	exports = {
		tailiscope = function()
			require("tailiscope").picker("base", opts)
		end,
		base = function()
			require("tailiscope").picker("base", opts)
		end,
		categories = function()
			require("tailiscope").picker("categories", opts)
		end,
		classes = function()
			require("tailiscope").picker("classes", opts)
		end,
		all = function()
			require("tailiscope").picker("all", opts)
		end,
	},
})
