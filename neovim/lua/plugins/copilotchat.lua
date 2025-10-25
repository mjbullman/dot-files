-- ================================
--  GitHub Copilot Configuration
--  Author: Martin Bullman
-- ================================

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
		{ "nvim-telescope/telescope.nvim" },
	},
	build = "make tiktoken",
	opts = {
		window = {
			layout = "vertical",
			width = 0.3,
		},
	},
}
