-- =======================
-- DAP Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio"
	},
	config = function()
		require("config.debugging")
	end,
}
