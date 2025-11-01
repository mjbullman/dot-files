-- =========================
--  Treesitter Plugin Setup
--  Author: Martin Bullman
-- =========================

return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("config.treesitter")
    end
}

