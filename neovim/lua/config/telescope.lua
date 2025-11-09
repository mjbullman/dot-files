-- ===============================
-- Telescope Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local builtin = require("telescope/builtin")
local actions = require("telescope.actions")

require("telescope").setup({
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
    defaults = {
        prompt_prefix = " 🔍 ",
        selection_caret = "➤ ",
        path_display = { "smart" },
        mappings = {
            i = {
                -- Navigation in list
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-l>"] = actions.select_default,

                -- Preview navigation
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                -- Additional useful mappings
                ["<Esc>"] = actions.close,
                ["<C-c>"] = actions.close,
            },
            n = {
                -- Normal mode navigation
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default,

                -- Preview navigation in normal mode
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                -- Close with q
                ["q"] = actions.close,
            },
        },
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".venv",
        },
    },
})

-- load telescope ui.
require("telescope").load_extension("ui-select")
