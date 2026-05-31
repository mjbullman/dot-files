-- ===============================
-- Codeium AI Configuration
-- Author: Martin Bullman
-- ===============================

require('codeium').setup({
    enable_chat = true,
    enable_cmp_source = false,  -- using Blink, not nvim-cmp
    virtual_text = {
        enable = false
    },
    workspace_root = {
        use_lsp = true
    },
})
