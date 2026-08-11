-- ===============================
-- Render Markdown Configuration
-- Author: Martin Bullman
-- ===============================

require('render-markdown').setup({
    -- render everything except the line the cursor is on, so the raw markdown
    -- is always editable in place (same model as Obsidian's live preview)
    anti_conceal = { enabled = true },

    heading = {
        sign = false,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        width = 'block',
        left_pad = 0,
        right_pad = 2,
    },

    code = {
        sign = false,
        width = 'block',
        right_pad = 2,
        language_pad = 1,
        border = 'thin',
    },

    bullet = {
        icons = { '●', '○', '◆', '◇' },
    },

    checkbox = {
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
    },

    -- Obsidian-style callouts: the vault leans on these heavily
    -- (> [!abstract], > [!tip]-, > [!info]- and friends)
    quote = { icon = '▎' },

    link = {
        hyperlink = '󰌷 ',
        wiki = { icon = '󱗖 ', highlight = 'RenderMarkdownWikiLink' },
    },

    -- markdown lives in repos too (README, CLAUDE.md, AGENTS.md), not just the vault
    file_types = { 'markdown' },
})

vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', {
    desc = 'Toggle markdown rendering',
})
