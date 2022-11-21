-- required imports for the telescope api
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

_G.tailiscope_config = tailiscope_config or {}

_G.paste = function(value)
	-- vim.notify("value is " .. value)
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
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { entry.value[2] })
		else
			local table_results = require("tailiscope.docs." .. entry.value[2])
			local values = {}
			for i, v in ipairs(table_results) do
				table.insert(values, v[1])
			end
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, values)
		end
	end,
})

local picker = function(filename, opts)
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
					if entry.doc then
						display = " " .. display
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
				map("n", "od", function()
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
						recursive_picker(table.remove(history))
					end
					return true
				end

				map("n", "b", back)

				map("i", "<c-b>", back)

				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection.value.base then
						paste(selection.value[1])
					else
						table.insert(history, filename)
						recursive_picker(selection.value[2])
					end
				end)
				return true
			end,
		})
		:find()
end

_G.recursive_picker = function(filename)
	filename = filename or "base"
	picker(filename, {})
end

-- recursive_picker("base")
return picker
