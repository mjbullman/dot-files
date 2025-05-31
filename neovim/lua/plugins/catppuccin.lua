-- =========================================================
-- Catppuccin Theme Configuration
-- Author: Martin Bullman
-- Description: Sets up the Catppuccin colorscheme with high priority
--              to ensure it loads before other UI plugins.
-- =========================================================

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "catppuccin"
    end
}
