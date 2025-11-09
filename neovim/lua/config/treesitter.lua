-- ===============================
-- Treesitter Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local config = require("nvim-treesitter.configs")

config.setup({
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "vue" },  -- Disable treesitter indent for Vue files
	},
})
