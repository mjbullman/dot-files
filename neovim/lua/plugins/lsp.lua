-- ==============================
-- LSP Keymaps Configuration
-- Author: Martin Bullman
-- ==============================

return {
    "nvim-lsp-keymaps", -- local-only plugin (no installation)
    dir = vim.fn.stdpath("config"), -- use config directory
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Create autocmd that fires when LSP attaches to buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Navigation
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
                    buffer = ev.buf,
                    desc = "Go to definition",
                })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
                    buffer = ev.buf,
                    desc = "Go to declaration",
                })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
                    buffer = ev.buf,
                    desc = "Go to implementation",
                })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, {
                    buffer = ev.buf,
                    desc = "Show references",
                })
                vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {
                    buffer = ev.buf,
                    desc = "Go to type definition",
                })

                -- Documentation
                vim.keymap.set("n", "K", vim.lsp.buf.hover, {
                    buffer = ev.buf,
                    desc = "Hover documentation",
                })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {
                    buffer = ev.buf,
                    desc = "Signature help",
                })
                vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, {
                    buffer = ev.buf,
                    desc = "Signature help (insert mode)",
                })

                -- Code actions
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
                    buffer = ev.buf,
                    desc = "Code action",
                })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
                    buffer = ev.buf,
                    desc = "Rename symbol",
                })

                -- Formatting
                vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
                    buffer = ev.buf,
                    desc = "Format buffer",
                })

                -- Workspace folders
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
                    buffer = ev.buf,
                    desc = "Add workspace folder",
                })
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
                    buffer = ev.buf,
                    desc = "Remove workspace folder",
                })
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, {
                    buffer = ev.buf,
                    desc = "List workspace folders",
                })
            end,
        })
    end,
}
