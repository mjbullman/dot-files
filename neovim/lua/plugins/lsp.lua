-- =======================
--  LSP Configuration
--  Author: Martin Bullman
-- =======================

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"html",
					"vuels",
                    "jdtls",
					"rust_analyzer",
				},

				automatic_enable = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- setup cababilities with language servers.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- setup langage server.
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.vuels.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = { command = "clippy" },
					},
				},
			})

			-- lsp keymaps.
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
