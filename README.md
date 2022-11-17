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
Recommended:
Setup in Lspconfig on attach
```
if client.name == "tailwindcss" then
  require('telescope').load_extension('tailiscope')
  vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tailiscope<cr>")
```

## Config
If you would like to change the path, you can do so like so
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
