-- =================================
-- Typescript/Javascript LSP Config
-- Author: Martin Bullman
-- =================================

-- vtsls.lua
local vue_language_server_path = vim.fn.stdpath('data')
    .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

-- fallback check
if vim.fn.isdirectory(vue_language_server_path) == 0 then
    local ok, registry = pcall(require, 'mason-registry')
    if ok and registry.has_package('vue-language-server') then
        vue_language_server_path = registry.get_package('vue-language-server'):get_install_path()
            .. '/node_modules/@vue/language-server'
    end
end

local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vtsls', '--stdio' },
    root_markers = { 'package.json', 'tsconfig.json' },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = { vue_plugin },
            },
        },
    },
    on_attach = function(client)
        if vim.bo.filetype == 'vue' then
            client.server_capabilities.semanticTokensProvider.full = false
        end
    end,
}
