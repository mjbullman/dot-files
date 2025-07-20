-- ==============================
-- Catppuccin Theme Configuration
-- Author: Martin Bullman
-- ==============================

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "catppuccin"
    end
}
