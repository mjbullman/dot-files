-- =======================
--  None-LS Configuration
--  Author: Martin Bullman
-- =======================

return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.completion.spell,
			},
		})

		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
	end,
}
