local config = require("projection.config")
local M = {}

config.setup() -- apply default setup

function M.setup(opts)
    config.setup(opts)
end

function M.auto_scan()
    local path = require("utils.path")
    path.auto_scan()
end

-- Scan Dirs when entering Vim each time
-- Might make a way to check if changes have been made to save on start time
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        M.auto_scan()
    end,
    once = true,
})

return M
