-- ===============================
-- Which-Key Configuration
-- Author: Martin Bullman
-- ===============================

require("which-key").setup({
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20,
        },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
    icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
    },
    win = {
        border = "rounded",
        padding = { 1, 2 },
    },
    layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
    },
})

-- =============================
-- Which-Key Group Labels
-- =============================
local wk = require("which-key")

wk.add({
    { "<leader>f", group = "Find (Telescope)" },
    { "<leader>a", group = "AI (ChatGPT)" },
    { "<leader>d", group = "Debug/Diagnostics" },
    { "<leader>l", group = "LSP/Language" },
    { "<leader>e", group = "Explorer (Neo-tree)" },
})
