-- =======================
--  Code Completions Configuration (Blink.cmp)
--  Author: Martin Bullman
-- =======================

return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "dsznajder/vscode-es7-javascript-react-snippets",  -- Better JS/React
            "hollowtree/vscode-vue-snippets",                  -- Vue 3 snippets
        },
        version = "*",
        opts = {
            keymap = {
                preset = "default",
                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide" },
                ["<C-y>"] = { "select_and_accept" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
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
                nerd_font_variant = "mono",
            },
            completion = {
                accept = { auto_brackets = { enabled = true } },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = { border = "rounded" },
                },
                ghost_text = { enabled = true },
            },
            fuzzy = {
                use_typo_resistance = true,
                frecency = { enabled = true },
                proximity = { enabled = true },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        max_items = 50,
                        score_offset = 100,
                        min_keyword_length = 1,
                    },
                    snippets = {
                        name = "snippets",
                        enabled = true,
                        max_items = 20,
                        score_offset = 50,
                        min_keyword_length = 2,
                    },
                    path = {
                        name = "path",
                        enabled = true,
                        max_items = 20,
                        score_offset = 3,
                        min_keyword_length = 0,
                    },
                    buffer = {
                        name = "buffer",
                        enabled = true,
                        max_items = 10,
                        score_offset = -3,
                        min_keyword_length = 3,
                    },
                },
            },
            signature = {
                enabled = true,
                window = { border = "rounded" },
            },
        },
    },
}
