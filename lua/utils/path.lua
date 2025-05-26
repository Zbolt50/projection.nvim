local config = require("projection.config")
-- Path finding and storing functions
local uv = vim.uv
local M = {}

-- [[ TODO:

--  Save project file paths to a good location to read/write from/to
--  Allow for the user to select whether they will manually add projects or let auto_scanning work
--  Integrate with Telescope to pick projects

--]]

-- Check if data dir exists, creates it if it doesn't
M.ensure_data_dir = function()
    local data_dir = config.options.datapath .. "/projection"
    vim.fn.mkdir(data_dir, "p")
    return data_dir
end

-- Return a table of strings of paths to valid directories based on user specified criteria Ex: .git folders, formatter files etc
---@param paths string[]
---@param filter string[]
---@param exclude string[]
---@return string[]
M.find_dirs = function(paths, filter, exclude)
    local dirs = {}
    -- Might want to add exclude_filters to opts so you can also not add certain folders to project dirs
    -- Might simplify this into the match function later
    local function is_excluded(pattern, excluded)
        for _, e in ipairs(excluded) do
            if pattern == e then
                return true
            end
        end
        return false
    end

    -- TODO: Add path normalization (Handling ~/dir vs ~/dir/)

    local function target_match(pattern)
        if is_excluded(pattern, exclude) then
            return false
        end
        for _, t in ipairs(filter) do
            -- Add exclusion here
            if pattern == t then
                return true
            end
        end
        return false
    end

    local function scan(dir)
        -- Pattern exclusion
        for _, ex in ipairs(exclude) do
            if vim.fn.expand(dir) == vim.fn.expand(ex) then
                print("Skipping excluded path:", dir)
                return
            end
        end

        local fd = uv.fs_scandir(dir)
        if not fd then
            return
        end

        while true do
            local name, type = uv.fs_scandir_next(fd)
            if not name then
                break
            end
            local full_path = dir .. "/" .. name

            if target_match(name) then
                table.insert(dirs, full_path)
            end
            if type == "directory" then
                scan(full_path) -- go into subdir
            end
        end
    end

    for _, path in ipairs(paths) do
        local expanded = vim.fn.expand(path)
        local stat = uv.fs_stat(expanded)
        if not stat or stat.type ~= "directory" then
            vim.notify("Invalid path: " .. path, vim.log.levels.WARN)
        else
            scan(expanded)
        end
    end

    return dirs
end

--- Write table of dirs (input) to file (output)
---@param dirs string[]
---@param output string
---@return nil
M.write_dirs = function(dirs, output)
    local data_dir = M.ensure_data_dir()
    local file_path = output and output ~= "" and output or (data_dir .. "/paths.txt") -- Check to see if different output path is specified, otherwise use default

    -- Default path will be to write to plugin folder
    local f, err = io.open(file_path, "w") -- Open file for writing
    if not f then
        vim.notify("Failed to open for writing: " .. err, vim.log.levels.ERROR)
        return
    end

    for _, dir in ipairs(dirs) do
        f:write(dir .. "\n")
    end
    f:close()

    vim.notify("Wrote project paths to: " .. file_path, vim.log.levels.INFO)
end

-- Make this run on an autocommand
M.auto_scan = function() -- Update these parameters later to take in user options and file args
    local opts = config.options
    local dirs = M.find_dirs(opts.paths, opts.filters, opts.exclude_paths)
    M.write_dirs(dirs, "")
end

return M
