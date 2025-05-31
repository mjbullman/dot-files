-- =========================================================
--  Treesitter Plugin Setup
--  Author: Martin Bullman
--  Description: Configures nvim-treesitter with language
--               parsers and enables highlighting and indent.
-- =========================================================

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

