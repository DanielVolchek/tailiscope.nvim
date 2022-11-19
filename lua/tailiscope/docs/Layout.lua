print("loading layout")

return {
	{
		"Breakpoints",
		function()
			recursive_picker("layout")
		end,
	},
	-- {
	-- 	"box-decoration-break",
	-- 	function()
	-- 		recursive_picker("box_decoration_break")
	-- 	end,
	-- },
	-- {
	-- 	"container",
	-- 	function()
	-- 		recursive_picker("container")
	-- 	end,
	-- },
}
