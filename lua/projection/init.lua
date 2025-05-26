local config = require("projection.config")
local M = {}

print("init.lua loaded...")
config.setup() -- apply default setup

function M.setup(opts)
    config.setup(opts)
end

function M.auto_scan()
    local path = require("utils.path")
    path.auto_scan()
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        M.auto_scan()
    end,
    once = true,
})

return M
