-- ========================
--  Bufferline Plugin Setup
--  Author: Martin Bullman
-- ========================

return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "catppuccin",
    },
    config = function()
        require("config/bufferline")
    end,
}
