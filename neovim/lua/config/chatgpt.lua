-- ===============================
-- ChatGPT Configuration
-- Author: Martin Bullman
-- ===============================

require('chatgpt').setup({
    api_key_cmd = 'echo $OPENAI_API_KEY',
    chat = {
        keymaps = {
            close = '<C-c>',
            yank_last = '<C-y>',
            scroll_up = '<C-u>',
            scroll_down = '<C-d>',
            new_session = '<C-n>',
            cycle_windows = '<Tab>',
            select_session = '<Space>',
            rename_session = 'r',
            delete_session = 'd',
        },
    },
    popup_layout = {
        default = 'center',
        center = {
            width = '80%',
            height = '80%',
        },
    },
    popup_window = {
        border = {
            style = 'rounded',
            text = {
                top = ' ChatGPT ',
            },
        },
    },
    openai_params = {
        model = 'gpt-4o',      -- change to 'gpt-4-turbo' or 'gpt-3.5-turbo' for different models
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4096,
        temperature = 0.7,     -- 0.0-2.0: Lower = more focused, Higher = more creative
        top_p = 1,
        n = 1,
    },
    openai_edit_params = {
        model = 'gpt-4o',      -- model for code editing
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0.2,     -- lower temp for more consistent code edits
        top_p = 1,
        n = 1,
    },
    actions_paths = {},
    -- use OpenAI functions for edits (more accurate)
    use_openai_functions_for_edits = false,
})


-- =============================
-- ChatGPT Keymaps
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>ai', ':ChatGPT<CR>', vim.tbl_extend('force', opts, {
    desc = 'Open ChatGPT'
}))
map({ 'n', 'v' }, '<leader>ae', ':ChatGPTEditWithInstructions<CR>', vim.tbl_extend('force', opts, {
    desc = 'Edit with AI'
}))
map('n', '<leader>ax', ':ChatGPTRun explain_code<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Explain code'
}))
map('n', '<leader>af', ':ChatGPTRun fix_bugs<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Fix bugs'
}))
map('n', '<leader>ao', ':ChatGPTRun optimize_code<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Optimize code'
}))
map('n', '<leader>ad', ':ChatGPTRun docstring<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Docstring'
}))
map('n', '<leader>at', ':ChatGPTRun add_tests<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Add tests'
}))
map({ 'n', 'v' }, '<leader>ag', ':ChatGPTRun grammar_correction<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Grammar'
}))
map('n', '<leader>as', ':ChatGPTActAs<CR>', vim.tbl_extend('force', opts, {
    desc = 'AI: Act as'
}))
