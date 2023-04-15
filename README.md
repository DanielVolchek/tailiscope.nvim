# tailiscope.nvim

Simple Telescope extension that mirrors the [nerdcave cheatsheet](https://nerdcave.com/tailwind-cheat-sheet)

Help maintain development flow within Neovim while using Tailwind CSS

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
require('telescope').setup({
	extensions = {
		tailiscope = {
			-- register to copy classes to on selection
			register = "a",
		 	-- indicates what picker opens when running Telescope tailiscope
			-- can be any file inside of docs dir but most useful opts are
			-- all, base, categories, classes
			-- These are also accesible by running Telescope tailiscope <picker>
			default = "base",
			-- icon indicates an item which can be opened in tailwind docs
			-- can be icon or false
			doc_icon = " ",
		  	-- if you would prefer to copy with/without class selector
		 	-- dot is maintained in display to differentiate class from other pickers
			no_dot = true,
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
}
```

### Useful changes

If you would like to set result to default register, set register = '"'

If you would like to open a searchable list of only classes when using :Telescope tailiscope command set default = "classes"

## Multi Select proposal

Here is come config for telescope that would allow you to choose multiple classes from the same list and add them to the value yanked in the register

```lua

function tailwind_multiselect(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())
    entries_to_add = {}

    local picker = action_state.get_current_picker(prompt_bufnr)
    for _, entry in ipairs(picker:get_multi_selection()) do
        class = string.gsub(entry.display, "^\\.", "")
        table.insert(entries_to_add, class)
    end
    entries_to_add = table.concat(entries_to_add, " ")
    vim.fn.setreg("*", entries_to_add)
end

require('telescope').setup {
  defaults = {
    mappings = {
          n = {
        ['<c-space>'] = tailwind_multiselect,
      }
    },
  }
}
```

Doesn't work over multiple lists if you go back with <C-h>
yank into system clipboard register '*'
remove leading dot '^.'

Maybe we can make it work over multiples categories ?

## Future update features

- Maintain search when going back through history
- Support multiselect to copy multiple classes to register
- Even possibly multiselect to open lists of lists together
- Match regex for colors and set highlight if the regex matches
- Get a list of default colors from tailwind docs, also check tailwind config for alternate colors (only matching default color groups)
