# tailiscope.nvim

Simple Telescope extension that mirrors the [nerdcave cheatsheet](https://nerdcave.com/tailwind-cheat-sheet)

## Demo

### Search through lists and copy what you need:

![](https://github.com/DanielVolchek/tailiscope-media/blob/main/gifs/main.gif)

### Go back between history:

![](https://github.com/DanielVolchek/tailiscope-media/blob/main/gifs/back.gif)

### Open Docs:

![](https://github.com/DanielVolchek/tailiscope-media/blob/main/gifs/docs.gif)

### Search through everything:

![](https://github.com/DanielVolchek/tailiscope-media/blob/main/gifs/all.gif)

## Setup

```lua
-- plugin setup
use("danielvolchek/tailiscope.nvim")
-- anywhere else
require('telescope').load_extension('tailiscope')
```

If you have tailwind lsp you can setup on attach

```lua
if client.name == "tailwindcss" then
  require('telescope').load_extension('tailiscope')
  vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tailiscope<cr>")
```

## Config

### Default Config

```lua
{
	register = "a",
  -- register to copy classes to on selection
  -- can be any file inside of docs dir but most useful opts are
  -- all, base, categories, classes
	default = "base",
	doc_icon = " ",
  -- icon or false
  no_dot = true,
  -- if you would prefer to copy with/without class selector
  -- dot is maintained in display to differentiate class from other pickers
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
}
```

### Useful changes

If you would like to set result to default register, set register = '"'

If you would like to open a searchable list of only classes when using :Telescope tailiscope command set default = "classes"

## Future update features

- Maintain search when going back through history
- Support multiselect to copy multiple classes to register
- Even possibly multiselect to open lists of lists together
- Match regex for colors and set highlight if the regex matches
- Get a list of default colors from tailwind docs, also check tailwind config for alternate colors (only matching default color groups)
