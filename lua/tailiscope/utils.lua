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
