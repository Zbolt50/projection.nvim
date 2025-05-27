local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}
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

return M
