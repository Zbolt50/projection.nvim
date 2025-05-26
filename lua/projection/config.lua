---@class ProjectionConfig
local M = {}

---@type ProjectionOptions
M.options = {}

---@class ProjectionOptions
local defaults = {
    -- projection looks here for paths by default, might add it via lsp later
    paths = { "" },
    -- NOTE: I forsee that maybe nested git repos might lead to project duplication

    -- Don't look here for projects
    exclude_paths = { "" },

    -- Filter project files to search for
    -- TODO: Add pattern globbing later
    filters = { ".git", "stylua.toml", ".clang-format" },

    -- Files made by the plugin will be stored here
    datapath = vim.fn.stdpath("data"),
}

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", defaults, options or {})
    -- Rest of setup goes here
end

return M
