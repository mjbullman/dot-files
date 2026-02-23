-- =================================
-- Typescript/Javascript LSP Config
-- Author: Martin Bullman
-- =================================

-- vtsls.lua
local vue_plugin_path = vim.fn.stdpath('data')
    .. '/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin'

-- fallback check
if vim.fn.isdirectory(vue_plugin_path) == 0 then
    local ok, registry = pcall(require, 'mason-registry')
    if ok and registry.has_package('vue-language-server') then
        vue_plugin_path = registry.get_package('vue-language-server'):get_install_path()
            .. '/node_modules/@vue/typescript-plugin'
    end
end

local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_plugin_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
    enableForWorkspaceTypeScriptVersions = true,
}

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vtsls', '--stdio' },
    root_markers = {
        'tsconfig.json',
        'jsconfig.json',
        'package.json',
        'pnpm-workspace.yaml',
        'yarn.lock',
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
        complete_function_calls = true,
        vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            tsserver = {
                maxTsServerMemory = 4096,
                globalPlugins = { vue_plugin },
            },
            experimental = {
                completion = {
                    enableServerSideFuzzyMatch = true,
                },
            },
        },
        typescript = {
            suggest = {
                completeFunctionCalls = true,
            },
            updateImportsOnFileMove = {
                enabled = 'always',
            },
            preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                includeCompletionsWithInsertText = true,
                includePackageJsonAutoImports = 'auto',
                importModuleSpecifierPreference = 'non-relative',
            },
        },
        javascript = {
            suggest = {
                completeFunctionCalls = true,
            },
            updateImportsOnFileMove = {
                enabled = 'always',
            },
            preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                includeCompletionsWithInsertText = true,
                includePackageJsonAutoImports = 'auto',
                importModuleSpecifierPreference = 'non-relative',
            },
        },
    },
    on_attach = function(client)
        if vim.bo.filetype == 'vue' then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end,
}
