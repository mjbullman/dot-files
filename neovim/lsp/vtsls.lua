-- =================================
-- Typescript/Javascript LSP Config
-- Author: Martin Bullman
-- =================================

-- Use the @vue/typescript-plugin@3.0.0 bundled inside @vue/language-server@3.0.0.
-- Mason's wrapper also installs a top-level @vue/typescript-plugin@3.2.4 which dropped
-- Vue 2 support in v3.1. The nested version (3.0.0) is required for Vue 2 / Vuetify 2.
local vue_plugin_path = vim.fn.stdpath('data')
    .. '/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'

-- fallback to outer node_modules if the nested path doesn't exist
if vim.fn.isdirectory(vue_plugin_path) == 0 then
    vue_plugin_path = vim.fn.stdpath('data')
        .. '/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin'
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
