-- ==============================
-- LSP Configuration
-- Author: Martin Bullman
-- ==============================

-- =============================
-- LSP UI configuration
-- =============================

-- add borders to LSP floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
})

-- better diagnostic configuration
vim.diagnostic.config({
    virtual_text = false, -- using tiny-inline-diagnostic instead
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '⚠',
            [vim.diagnostic.severity.HINT] = '󰞋',
            [vim.diagnostic.severity.INFO] = 'ℹ',
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'if_many', -- show source if multiple
        header = '',
        prefix = '',
    },
})

-- enable inlay hints by default (types, parameter names, etc.)
vim.lsp.inlay_hint.enable(true)

-- =============================
-- LSP server configuration
-- =============================

-- configure LSP with Blink.cmp capabilities (applies to all servers)
-- individual server configs are auto-loaded from lsp/<name>.lua by vim.lsp.enable()
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    root_markers = { '.git' },
})

-- enable all LSP servers
vim.lsp.enable({
    'ruff',
    'vtsls',
    'lua_ls',
    'vue_ls',
    'clangd',
    'css_ls',
    'jsonls',
    'bashls',
    'html_ls',
    'marksman',
    'eslint_ls',
    'basedpyright',
    'rust_analyzer',
})

-- =============================
-- LSP keymaps (global)
-- =============================

-- toggle inlay hints
vim.keymap.set('n', '<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.notify('Inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled()), vim.log.levels.INFO)
end, { desc = 'Toggle inlay hints' })

-- LSP management
vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<cr>', { desc = 'LSP Info' })
vim.keymap.set('n', '<leader>ll', '<cmd>LspLog<cr>', { desc = 'LSP Log' })
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<cr>', { desc = 'LSP Restart' })

-- =============================
-- LSP keymaps (buffer-local)
-- =============================

-- create autocmd that fires when LSP attaches to buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- navigation with Telescope LSP pickers (better UI)
        vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {
            buffer = ev.buf,
            desc = 'Go to definition',
        })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
            buffer = ev.buf,
            desc = 'Go to declaration',
        })
        vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', {
            buffer = ev.buf,
            desc = 'Go to implementation',
        })
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {
            buffer = ev.buf,
            desc = 'Show references',
        })
        vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', {
            buffer = ev.buf,
            desc = 'Go to type definition',
        })

        -- document/workspace symbols with Telescope
        vim.keymap.set('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>', {
            buffer = ev.buf,
            desc = 'Document symbols',
        })
        vim.keymap.set('n', '<leader>lS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', {
            buffer = ev.buf,
            desc = 'Workspace symbols',
        })

        -- documentation
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
            buffer = ev.buf,
            desc = 'Hover documentation',
        })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {
            buffer = ev.buf,
            desc = 'Signature help',
        })
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, {
            buffer = ev.buf,
            desc = 'Signature help (insert mode)',
        })

        -- code actions
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {
            buffer = ev.buf,
            desc = 'Code action',
        })
        vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.code_action({ apply = true })
        end, {
            buffer = ev.buf,
            desc = 'Quick fix (apply first action)',
        })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
            buffer = ev.buf,
            desc = 'Rename symbol',
        })

        -- formatting is handled by conform.nvim (see config/conform.lua)

        -- workspace folders
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {
            buffer = ev.buf,
            desc = 'Add workspace folder',
        })
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {
            buffer = ev.buf,
            desc = 'Remove workspace folder',
        })
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, {
            buffer = ev.buf,
            desc = 'List workspace folders',
        })

        -- codelens support (useful for Rust, Java, etc.)
        if vim.lsp.codelens then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                buffer = ev.buf,
                callback = vim.lsp.codelens.refresh,
            })

            vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {
                buffer = ev.buf,
                desc = 'Run CodeLens',
            })
        end
    end,
})
