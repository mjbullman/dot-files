-- =========================
--  Treesitter Configuration
--  Author: Martin Bullman
-- =========================

return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_enstalled = {"lua", "javascript", "php", "java"},
            highlight = { enabled = true },
            indent = { enabled = true }
        })
    end
}

