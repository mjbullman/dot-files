-- ===============================
-- Blink.cmp Configuration
-- Author: Martin Bullman
-- ===============================

require('blink.cmp').setup({
    enabled = function()
        -- disable in ChatGPT input windows and prompts
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
        local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })

        -- disable in prompt buffers (ChatGPT input)
        if buftype == 'prompt' then
            return false
        end

        -- disable in ChatGPT-related filetypes
        if filetype == 'chatgpt-input' or filetype == 'chatgpt' then
            return false
        end

        return true
    end,
    keymap = {
        preset = 'default',
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'accept', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    snippets = {
        expand = function(snippet)
            vim.snippet.expand(snippet)
        end,
        active = function(filter)
            return vim.snippet.active(filter)
        end,
        jump = function(direction)
            vim.snippet.jump(direction)
        end,
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
            border = 'rounded',
            draw = {
                columns = {
                    { 'kind_icon' },
                    { 'label', 'label_description', gap = 1 },
                    { 'kind' }
                },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
                border = 'rounded'
            },
        },
        ghost_text = {
            enabled = true
        },
    },
    fuzzy = {
        enabled = true,
        threshold = 3
    },
    sources = {
        default = {
            'lsp',
            'path',
            'snippets',
            'buffer',
            'lazydev',
            'codeium'
        },
        providers = {
            codeium = {
                name = 'Codeium',
                module = 'codeium.blink',
                score_offset = 85,
                async = true,
            },
            lsp = {
                name = 'lsp',
                enabled = true,
                max_items = 50,
                score_offset = 100,
                min_keyword_length = 1,
            },
            lazydev = {
                name = 'lazydev',
                module = 'lazydev.integrations.blink',
                score_offset = 95,  -- Higher than snippets, lower than LSP
            },
            snippets = {
                name = 'snippets',
                enabled = true,
                max_items = 20,
                score_offset = 50,
                min_keyword_length = 2,
            },
            path = {
                name = 'path',
                enabled = true,
                max_items = 20,
                score_offset = 3,
                min_keyword_length = 0,
            },
            buffer = {
                name = 'buffer',
                enabled = true,
                max_items = 10,
                score_offset = -3,
                min_keyword_length = 3,
            },
        },
    },
    signature = {
        enabled = true,
        window = {
            border = 'rounded'
        },
    },
})
