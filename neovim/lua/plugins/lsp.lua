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

			local lsp = vim.lsp.config

			-- setup langage server.
			lsp("lua_ls", {
				capabilities = capabilities,
			})
			lsp("tsserver", {
				capabilities = capabilities,
			})
			lsp("html", {
				capabilities = capabilities,
			})
			lsp("vuels", {
				capabilities = capabilities,
			})
			lsp("rust_analyzer", {
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
