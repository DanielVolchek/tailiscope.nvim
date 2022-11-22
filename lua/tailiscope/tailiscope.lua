-- required imports for the telescope api
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local U = require("tailiscope.utils")

M = {}

M.config = {
	register = "a",
	default = "base",
	doc_icon = " ", -- icon or false
	maps = {
		i = {
			back = "<C-h>",
			open_doc = "<C-o>",
		},
		n = {
			back = "b",
			open_doc = "od",
		},
	},
	colors = {},
}

M._highlights = {}

-- https://stackoverflow.com/questions/295052/how-can-i-determine-the-os-of-the-system-from-within-a-lua-script
-- I haven't tested this outside of osx but it should work

M._history = {}

M.previewer = previewers.new_buffer_previewer({
	-- previewer is generated from the same object we would require (unless we have class)
	define_preview = function(self, entry)
		local bufnr = self.state.bufnr
		local values = {}
		-- base in this case refers to a lowest level function with css instead of a sub item sheet
		if entry.value.base then
			-- split the css definition by |
			values = U.split_string(entry.value[2], "|")
		else
			-- otherwise we get the subitem and write it into the preview buffer
			local table_results = require("tailiscope.docs." .. entry.value[2])

			-- desc appears on 2nd level (aka layout -> breakpoints)
			if entry.value["desc"] then
				table.insert(values, entry.value.desc)
				table.insert(values, "")
				table.insert(values, "Classes: ")
			end

			for _, v in ipairs(table_results) do
				table.insert(values, v[1])
			end
		end
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, values)
	end,
})

M.picker = function(filename, opts)
	filename = filename or "base"
	local results = require("tailiscope.docs." .. filename)
	opts = opts or {}
	opts["results_title"] = filename
	pickers
		.new(opts, {
			previewer = M.previewer,
			prompt_title = "Search",
			results_title = filename,
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					local display = entry[1]
					-- if the entry has documentation online, show it with a configurable icon
					-- afaik this only applies to the container subclass
					-- It's probably better to change this in the build script so we don't check every time
					if entry[1] == " " then
						display = "<BLANK>"
					end
					if entry.doc and M.config.doc_icon then
						display = M.config.doc_icon .. display
					end
					return {
						value = entry,
						display = display,
						ordinal = entry[1],
					}
				end,
			}),

			layout_config = {
				width = 0.75,
				height = 0.75,
			},

			-- may include the requires within the search in the future
			-- also maybe set that to optional since it would likely slow it down requiring every file all at once to search
			sorter = conf.generic_sorter(opts),

			attach_mappings = function(prompt_bufnr, map)
				-- open the documentation for the class if it has doc_icon next to the name
				map("n", M.config.maps.n.open_doc, function()
					local selection = action_state.get_selected_entry()
					if selection.value.doc then
						U.open_doc(selection.value.doc, "")
					end

					return true
				end)

				-- go back in history
				local back = function()
					if next(M._history) ~= nil then
						actions.close(prompt_bufnr)
						M.picker(table.remove(M._history), opts)
					end
					return true
				end

				map("n", M.config.maps.n.back, back)

				map("i", M.config.maps.i.back, back)

				-- enter
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- if entry is base (aka class) copy to register
					-- the naming convention is a bit weird since I have base as both the lowest for classes and the highest for categories
					-- I'll fix that later
					if selection.value.base then
						-- TODO add multiselect support to copy multiple classes to buffer
						U.paste(selection.value[1])
					else
						-- otherwise recursively open entry
						table.insert(M._history, filename)
						M.picker(selection.value[2], opts)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
