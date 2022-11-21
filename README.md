# tailiscope-nvim

Very simple telescope extension to open tailwind docs from Neovim. Inspired by [Tailwind Docs](https://github.com/austenc/vscode-tailwind-docs) for VSCode.

## Setup

Setup is equally simple

```
-- plugin setup
use("danielvolchek/tailiscope-nvim")
-- anywhere else
require('telescope').load_extension('tailiscope')
```

You're done!
Open it using :Telescope tailiscope

If you'd like, you can setup in Lspconfig on attach like so

```
if client.name == "tailwindcss" then
  require('telescope').load_extension('tailiscope')
  vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tailiscope<cr>")
```

## Config

If you would like to change the path, you can do so

```
require('telescope').setup({
  extensions = {
    tailiscope = {
      path = "http://localhost:3000/docs/"
    }
  }
})
```

This is useful if you're hosting the docs on your own machine for whatever reason

### Cheatsheet

I have included the nerdcave cheat sheet as an additional link. Same idea applies if you're hosting your own cheatsheet

```
require('telescope').setup({
  extensions = {
    tailiscope = {
      cheatpath = "http://localhost:3000/"
    }
  }
})
```

### Build tool

The build tool for the links is hosted on build/build.py
Full credit to [Austen](https://github.com/austenc/vscode-tailwind-docs/blob/master/build/build.py) for it.

## Next

Tailwind Cheatsheet

### Should ->

1. Get headers (layout,flex, etc...)
   1. Include them as their own picker
   1. Which will show all the subheaders in previewer
   1. And will open the related picker
1. Get subheaders
   1. Which will show all the associated classes in the previewer
   1. And have an option to open up the associated doc page with an alternate keypress
   1. On open will go to another picker with a list of item
1. Get list
   1. Which will show a list of the actual tailwind class as value
   1. And in preview show what the class is defined as
   1. On open copy to configured buffer

First thing to do is create selenium script for getting all the data from nerdcave
script should

1. get all divs
2. check for correct header type
3. get sub tag
4. iterate through table
5. Repeat for every div with header

Next is to figure out how to format the data
current ideas are

1.  - function() recursive("processed_filename") end
    - function() paste("classname") end
2.

- "function", "filename", doc = "x"

leaning towards 2 rn so we can have better checking for doc and classname

Last bits:

- Full lists of all classes to search through
- Full lists of all categories to search through
- Fix CSS displaying newlines with replaced characters
- Descriptions!
- Add paste functionality
- Add opts
- Add hook function
- Add multiselect option for classes
- Clean everything up
