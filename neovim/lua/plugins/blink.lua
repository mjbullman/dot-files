-- =======================
--  Code Completions Plugin (Blink.cmp)
--  Author: Martin Bullman
-- =======================

return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'dsznajder/vscode-es7-javascript-react-snippets',  -- Better JS/React
        'hollowtree/vscode-vue-snippets',                  -- Vue 3 snippets
    },
    version = '*',
    config = function()
        require('config.blink')
    end,
}
