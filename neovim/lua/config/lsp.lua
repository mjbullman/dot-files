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
    signs = true,
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

-- customize diagnostic signs (Unicode icons)
local signs = {
    Error = '✘',
    Warn = '⚠',
    Hint = '💡',
    Info = 'ℹ'
}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- enable inlay hints by default (types, parameter names, etc.)
vim.lsp.inlay_hint.enable(true)

-- =============================
-- LSP server configuration
-- =============================

-- configure LSP with Blink.cmp capabilities
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    root_markers = { '.git' },
})

-- configure lua_ls for Neovim development
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- enable all LSP servers
vim.lsp.enable({
    'vtsls',
    'jdtls',
    'lua_ls',
    'vue_ls',
    'clangd',
    'css_ls',
    'rust_analyzer',
    'html_ls',
    'eslint_ls',
    'basedpyright',
    'jsonls',
    'marksman',
    'bashls',
    'dockerls',
})

-- =============================
-- LSP progress notifications
-- =============================

vim.lsp.handlers['$/progress'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local value = result.value

    if not client then
        return
    end

    -- show notification for significant progress
    if value.kind == 'begin' then
        vim.notify(value.title, vim.log.levels.INFO, {
            title = client.name,
            timeout = 1000,
        })
    end
end

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

        -- formatting
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {
            buffer = ev.buf,
            desc = 'Format buffer',
        })

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
