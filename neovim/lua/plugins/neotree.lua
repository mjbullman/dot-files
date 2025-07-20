-- =======================
--  Neo-tree Configuration
--  Author: Martin Bullman
-- =======================

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy=false,
    config = function()
        -- open Neo-tree in left position
        vim.keymap.set("n", "<C-q>", ":Neotree toggle left<CR>", {
            desc = "Toggle Neo-tree (left)"
        })

        -- reveal current file in Neo-tree
        -- vim.keymap.set("n", "<leader>o", ":Neotree reveal<CR>", {
            -- desc = "Reveal file in Neo-tree"
        -- })

        -- open Neo-tree in floating window
        -- vim.keymap.set("n", "<leader>f", ":Neotree toggle float<CR>", {
            -- desc = "Toggle Neo-tree (float)"
        -- })

        -- vim.keymap.set("n", "<leader>e", ":Neotree focus<CR>", {
            --desc = "Focus Neo-tree"
        -- })

        -- Neo-tree setup
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true,         -- Show all files, even hidden ones
                    hide_dotfiles = false,  -- Do NOT hide dotfiles
                    hide_gitignored = false, -- Optional: show .gitignored files
                },
            },
        })
    end
}

