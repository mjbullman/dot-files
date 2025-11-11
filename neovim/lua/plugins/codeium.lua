-- =======================
-- Codeium AI Completions (Blink-only, no nvim-cmp)
-- Author: Martin Bullman
-- =======================

return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "InsertEnter",
    config = function()
        require("codeium").setup({
            enable_chat = true,
            enable_cmp_source = false,  -- We're using Blink, not nvim-cmp
        })
    end,
}
