-- =======================
--  LSP Keymaps & Autocmds
--  Optimized for JS/TS/Vue Frontend Development
-- =======================

return {
  "neovim/nvim-lspconfig",
  event = "LspAttach",
  config = function()
    local keymap = vim.keymap
    local severity = vim.diagnostic.severity

    -- Setup LspAttach keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Navigation
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Show implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Go to type definition"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        -- Code actions & refactoring
        opts.desc = "Code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Rename symbol"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Format document"
        keymap.set("n", "<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- Diagnostics
        opts.desc = "Buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Previous diagnostic"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts)

        -- Documentation
        opts.desc = "Hover documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- LSP Management
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        opts.desc = "Toggle inlay hints"
        keymap.set("n", "<leader>ih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, opts)
      end,
    })

    -- Diagnostic signs and config
    vim.diagnostic.config({
      signs = {
        text = {
          [severity.ERROR] = "✘",
          [severity.WARN] = "▲",
          [severity.HINT] = "➤",
          [severity.INFO] = "ℹ",
        },
        linehl = {
          [severity.ERROR] = "DiagnosticSignError",
          [severity.WARN] = "DiagnosticSignWarn",
          [severity.HINT] = "DiagnosticSignHint",
          [severity.INFO] = "DiagnosticSignInfo",
        },
        numhl = {
          [severity.ERROR] = "DiagnosticSignError",
          [severity.WARN] = "DiagnosticSignWarn",
          [severity.HINT] = "DiagnosticSignHint",
          [severity.INFO] = "DiagnosticSignInfo",
        },
      },
      virtual_text = {
        prefix = "●",
        spacing = 4,
        severity = { min = severity.WARN },
      },
      update_in_insert = false,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      severity_sort = true,
    })
  end,
}
