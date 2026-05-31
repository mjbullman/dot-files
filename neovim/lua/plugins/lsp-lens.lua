-- =======================
-- LSP Lens Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'VidocqH/lsp-lens.nvim',
    event = 'LspAttach',
    config = function()
        require('config.lsp-lens')
    end,
}
