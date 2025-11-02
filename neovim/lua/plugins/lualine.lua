-- =======================
-- Lualine Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("config.lualine")
    end
}
