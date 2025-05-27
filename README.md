# projection.nvim 

 **projection.nvim** is my first attempt at making a neovim plugin after trying multiple project management plugins and not caring for how they worked.

## Requirements
 Neovim >= 0.11.0

## Features

- Project pattern finding for easy access.
- Telescope integration 

### Planned Features
- Project tracking and removal via the telescope picker
- Potential support for fzf based pickers 
    - Currently, only telescope.nvim is supported

## Installation

Install via your favorite package manager: 

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

Ex:
```lua
return {
    "Zbolt50/projection.nvim",
    -- The following defaults are included
    -- NOTE: some of these I haven't implemented fully, but have kept them in the docs just as a reminder they exist
    config = function()
    require("projection").setup({
        -- projection looks here for paths by default, might add it via lsp later
        paths = { "" },

        -- Don't look here for projects
        exclude_paths = { "" },

        -- Filter project files to search for
        filters = { ".git", "stylua.toml" },

        -- User option to allow for manual project tracking
        auto_scan_paths = true,

        -- Files made by the plugin will be stored here
        datapath = vim.fn.stdpath("data"),
    })
    end,
}
```


