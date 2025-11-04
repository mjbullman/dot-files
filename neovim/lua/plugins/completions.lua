-- =======================
--  Code Completions Configuration (Blink.cmp)
--  Author: Martin Bullman
-- =======================

return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
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
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        menu = { border = "rounded" },
        documentation = { border = "rounded" },
        ghost_text = { enabled = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            max_items = 50,
            score_offset = 100,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 20,
            score_offset = 50,
          },
          path = {
            name = "path",
            enabled = true,
            max_items = 20,
          },
          buffer = {
            name = "buffer",
            enabled = true,
            max_items = 10,
            score_offset = -10,
          },
        },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
}
