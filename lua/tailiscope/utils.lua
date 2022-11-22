U = {}

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

U.open_doc = function(docfile, path)
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

-- split string by delimiter
U.split_string = function(str, char)
	local t = {}
	for i in string.gmatch(str, "([^" .. char .. "]+)") do
		table.insert(t, i)
	end
	return t
end

-- set highlights from config table return list of highlights
U.set_highlight = function(colors) end

-- in progress
-- check regex, if color matches, return correct highlight
U.get_highlight = function(str, colors, highlights)
	print("str is " .. str)
	-- todo convert this to vim compatible regex
	local pattern =
		"\\(.\\+[^-]\\).\\(red\\|blue\\|indigo\\|coolgray\\|pink\\|yellow\\|teal\\|gray\\|orange\\|green\\|purple\\).\\(50\\|100\\|200\\|300\\|400\\|500\\|600\\|700\\|800\\|900\\)"
	print("pattern is " .. pattern)
	local regex = vim.regex(pattern)
	return regex:match_str(str)
end

U.paste = function(value, no_dot)
	if no_dot then
		value = value:gsub("^.", "")
	end
	-- vim.notify("value is " .. value)
	vim.fn.setreg(M.config.register, value)
end

return U
