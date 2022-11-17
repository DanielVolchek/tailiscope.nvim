-- required imports for the telescope api
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local results = require("tailiscope.docs")

-- https://stackoverflow.com/questions/295052/how-can-i-determine-the-os-of-the-system-from-within-a-lua-script
-- I don't have a windows machine to test this on, but it should work
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

-- picker
return function(opts)
	opts = opts or {}
	vim.notify("opts are ")
	vim.notify(vim.inspect(opts))
	local cheat_opt = opts.cheatpath or "https://nerdcave.com/tailwind-cheat-sheet"
	local path = opts.path or "https://tailwindcss.com/docs/"
	pickers
		.new(opts, {
			prompt_title = "Tailiscope",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry[1],
						ordinal = entry[1],
					}
				end,
			}),

			layout_config = {
				width = 0.5,
				height = 0.75,
			},

			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local _path = path
					local selection = action_state.get_selected_entry()
					local doc = selection.value[2]
					if doc == "cheat-sheet" then
						_path = cheat_opt
						doc = ""
					end
					open_doc(doc, _path)
				end)
				return true
			end,
		})
		:find()
end
