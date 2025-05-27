local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}

-- Pass in opts and data as a table of strings to project picker
---@param opts any
---@param data string[]:
M.project_picker = function(opts, data)
    opts = opts or {}
    pickers
        .new(opts, {
            prompt_title = "Projects",
            finder = finders.new_table({
                results = data,
            }),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

M.browse_projects = function(opts)
    opts = opts or {}
    local file_path = vim.fn.stdpath("data") .. "/projection/paths.txt"
    local lines = {}

    local f = io.open(file_path, "r")
    if not f then
        vim.notify("No project paths file exists!", vim.log.levels.ERROR)
        return
    end

    for line in f:lines() do
        table.insert(lines, line)
    end
    f:close()

    M.project_picker(opts, lines)
end

-- Delete a project from the list
-- I forsee issues with it getting readded by the auto-scan, so I will have a blacklist.txt or something to ensure it doesn't come back
-- I can also add the option to pick through that if you accidentally blacklist the wrong folder
-- Adding the ability to add a project via command mode either is also a good idea
M.delete_project = function(path) end

return M
