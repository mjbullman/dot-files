-- ===============================
-- LSP Lens Configuration
-- Author: Martin Bullman
-- ===============================

require('lsp-lens').setup({
    enable = true,
    include_declaration = false,
    sections = {
        definition   = false,
        references   = true,
        implements   = true,
        git_authors  = false,
    },
    ignore_filetype = {
        'TelescopePrompt',
    },
})

vim.keymap.set('n', '<leader>tl', '<cmd>LspLensToggle<cr>', { desc = 'Toggle LSP lens' })
