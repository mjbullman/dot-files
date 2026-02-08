-- =======================
--  Code Completions Plugin (Blink.cmp)
--  Author: Martin Bullman
-- =======================

return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'dsznajder/vscode-es7-javascript-react-snippets',  -- JS/React/TS
        'hollowtree/vscode-vue-snippets',                  -- Vue 3
        'cstrap/python-snippets',                          -- Python
    },
    version = '*',
    config = function()
        require('config.blink')
    end,
}
