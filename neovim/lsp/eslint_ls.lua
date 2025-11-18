-- ==============================
-- Eslint LSP Config
-- Author: Martin Bullman
-- ==============================

local eslint_config_files = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
    "package.json", -- for eslintConfig in package.json
}

return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
    },
    root_markers = { "package.json", ".git" },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
            client:request_sync("workspace/executeCommand", {
                command = "eslint.applyAllFixes",
                arguments = {
                    {
                        uri = vim.uri_from_bufnr(bufnr),
                        version = vim.lsp.util.buf_versions[bufnr],
                    },
                },
            }, nil, bufnr)
        end, {})
    end,
    settings = {
        validate = "on",
        packageManager = nil,
        useESLintClass = false,
        experimental = {
            useFlatConfig = false,
        },
        codeActionOnSave = {
            enable = false,
            mode = "all",
        },
        format = true,
        quiet = false,
        onIgnoredFiles = "off",
        rulesCustomizations = {},
        run = "onType",
        problems = {
            shortenToSingleLine = false,
        },
        nodePath = "",
        workingDirectory = { mode = "auto" },
        codeAction = {
            disableRuleComment = {
                enable = false,  -- Disable "disable rule" suggestions
                location = "separateLine",
            },
            showDocumentation = {
                enable = false,  -- Disable "show docs" suggestions
            },
        },
    },
    handlers = {
        ["eslint/openDoc"] = function(_, result)
            if result then
                vim.ui.open(result.url)
            end
            return {}
        end,
        ["eslint/confirmESLintExecution"] = function()
            return 4 -- approved
        end,
        ["eslint/probeFailed"] = function()
            vim.notify("[ESLint] Probe failed.", vim.log.levels.WARN)
            return {}
        end,
        ["eslint/noLibrary"] = function()
            vim.notify("[ESLint] Unable to find ESLint library.", vim.log.levels.WARN)
            return {}
        end,
    },
}
