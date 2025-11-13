-- =========================
-- Inline Diagnostic Plugin
-- Author: Martin Bullman
-- =========================

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
        require("config.inline-diagnostic")
    end
}
