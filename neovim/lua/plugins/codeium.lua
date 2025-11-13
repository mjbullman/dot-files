-- =======================
-- Codeium Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "InsertEnter",
    config = function()
        require("config.codeium")
    end,
}
