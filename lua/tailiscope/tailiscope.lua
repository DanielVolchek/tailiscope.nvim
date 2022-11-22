-- required imports for the telescope api
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_utils = require("telescope.actions.utils")
local action_state = require("telescope.actions.state")

M = {}
M.config = {
	register = "a",
	default = "base",
	doc_icon = " ", -- icon or false
	map = {
		i = {
			back = "<C-h>",
			open_doc = "<C-o>",
		},
		n = {
			back = "b",
			open_doc = "od",
		},
	},
}

M.paste = function(value)
	-- vim.notify("value is " .. value)
	vim.fn.setreg(M.config.register, value)
end

-- https://stackoverflow.com/questions/295052/how-can-i-determine-the-os-of-the-system-from-within-a-lua-script
-- I haven't tested this outside of osx but it should work

local getOperatingSystem = function()
	local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
	if BinaryFormat == "dll" then
		function os.name()
			return "Windows"
		end
	elseif BinaryFormat == "so" then
		function os.name()
			return "Linux"
		end
	elseif BinaryFormat == "dylib" then
		function os.name()
			return "MacOS"
		end
	end
	BinaryFormat = nil
end

-- for classes
-- can't pass value with newlines so instead we split by char | in previewer
-- split string by delimiter
local split_string = function(str, char)
	local t = {}
	for i in string.gmatch(str, "([^" .. char .. "]+)") do
		table.insert(t, i)
	end
	return t
end

local open_doc = function(docfile, path)
	path = path or "https://tailwindcss.com/docs/"
	docfile = docfile or "index"
	local prefix = 'open "'
	local _os = getOperatingSystem()
	if _os == "Windows" then
		prefix = 'start "'
	elseif _os == "Linux" then
		prefix = 'xdg-open "'
	end
	local command = prefix .. path .. docfile .. '"'
	os.execute(command)
end

local history = {}

local previewer = previewers.new_buffer_previewer({
	define_preview = function(self, entry, status)
		local bufnr = self.state.bufnr
		if entry.value.base then
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, split_string(entry.value[2], "|"))
		else
			local table_results = require("tailiscope.docs." .. entry.value[2])
			local values = {}

			if entry.value["desc"] then
				table.insert(values, entry.value.desc)
				table.insert(values, "")
				table.insert(values, "Classes: ")
			end

			for _, v in ipairs(table_results) do
				table.insert(values, v[1])
			end
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, values)
		end
	end,
})

M.picker = function(filename, opts)
	filename = filename or "base"
	local results = require("tailiscope.docs." .. filename)
	opts = opts or {}
	pickers
		.new(opts, {
			previewer = previewer,
			prompt_title = "Search",
			results_title = filename,
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					local display = entry[1]
					-- if the entry has documentation online, show it with a configurable icon
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

			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				-- back
				map("n", M.config.map.n.open_doc, function()
					local selection = action_state.get_selected_entry()
					if selection.value.doc then
						open_doc(selection.value.doc, "")
					end

					return true
				end)

				-- back functionality

				local back = function()
					if next(history) ~= nil then
						actions.close(prompt_bufnr)
						vim.notify(vim.inspect(history))
						M.picker(table.remove(history), opts)
					end
					return true
				end

				map("n", M.config.map.n.back, back)

				map("i", M.config.map.i.back, back)

				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection.value.base then
						-- get multiselection if applicable and pass to paste
						-- not sure why this isn't working I must be doing something wrong
						-- local results = {}
						--
						-- local current_picker = action_state.get_current_picker(prompt_bufnr)
						-- action_utils.map_selections(prompt_bufnr, function(entry, index)
						-- 	table.insert(results, entry.value[1])
						-- end)

						M.paste(selection.value[1])
					else
						table.insert(history, filename)
						M.picker(selection.value[2], opts)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
