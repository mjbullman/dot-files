-- =========================================================
--  Neo-tree Configuration
--  Author: Martin Bullman
--  Description: Sets up Neo-tree for file exploration with custom
--               keybindings and floating/side panel options.
-- =========================================================

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- open Neo-tree in left position
        vim.keymap.set("n", "<C-q>", ":Neotree toggle left<CR>", {
            desc = "Toggle Neo-tree (left)"
        })

        -- reveal current file in Neo-tree
        vim.keymap.set("n", "<leader>o", ":Neotree reveal<CR>", {
            desc = "Reveal file in Neo-tree"
        })

        -- open Neo-tree in floating window
        vim.keymap.set("n", "<leader>f", ":Neotree toggle float<CR>", {
            desc = "Toggle Neo-tree (float)"
        })
    end
}

