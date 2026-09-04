-- ==============================
-- Eslint LSP Config
-- Author: Martin Bullman
-- ==============================

local eslint_config_files = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
    'package.json', -- for eslintConfig in package.json
}

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/vscode-eslint-language-server',
        '--stdio',
    },
    filetypes = {
        'vue',
        'astro',
        'svelte',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    -- Only start where ESLint is actually configured. Matching on `.git` or a
    -- bare `package.json` starts the server in every JS project, and one with no
    -- ESLint installed then notifies 'Unable to find ESLint library' on open.
    -- Not calling `on_dir` is how vim.lsp.config declines to start a server.
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == '' then
            return
        end

        for dir in vim.fs.parents(fname) do
            for _, name in ipairs(eslint_config_files) do
                local path = dir .. '/' .. name
                if vim.uv.fs_stat(path) then
                    -- package.json only counts when it carries an eslintConfig block
                    if name ~= 'package.json' then
                        return on_dir(dir)
                    end
                    local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
                    if ok and type(pkg) == 'table' and pkg.eslintConfig then
                        return on_dir(dir)
                    end
                end
            end
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
            client:request_sync('workspace/executeCommand', {
                command = 'eslint.applyAllFixes',
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
        validate = 'on',
        packageManager = nil,
        useESLintClass = false,
        codeActionOnSave = {
            enable = false,
            mode = 'all',
        },
        -- Do not remove: the server does an unguarded read of
        -- `settings.experimental.useFlatConfig`, so dropping the table crashes
        -- textDocument/diagnostic. `false` selects the standard `eslint` entry
        -- point (`true` picks `eslint/use-at-your-own-risk`, for v8.21-8.56).
        -- Flat config is detected separately off the *top-level* useFlatConfig,
        -- which stays unset — so ESLint 9 flat config works with this at false.
        experimental = {
            useFlatConfig = false,
        },
        format = false, -- conform.nvim + prettier own formatting
        quiet = false,
        onIgnoredFiles = 'off',
        rulesCustomizations = {},
        run = 'onType',
        problems = {
            shortenToSingleLine = false,
        },
        nodePath = '',
        workingDirectory = { mode = 'auto' },
        codeAction = {
            disableRuleComment = {
                enable = false, -- Disable 'disable rule' suggestions
                location = 'separateLine',
            },
            showDocumentation = {
                enable = false, -- Disable 'show docs' suggestions
            },
        },
    },
    handlers = {
        ['eslint/openDoc'] = function(_, result)
            if result then
                vim.ui.open(result.url)
            end
            return {}
        end,
        ['eslint/confirmESLintExecution'] = function()
            return 4 -- approved
        end,
        ['eslint/probeFailed'] = function()
            vim.notify('[ESLint] Probe failed.', vim.log.levels.WARN)
            return {}
        end,
        ['eslint/noLibrary'] = function()
            vim.notify('[ESLint] Unable to find ESLint library.', vim.log.levels.WARN)
            return {}
        end,
    },
}
