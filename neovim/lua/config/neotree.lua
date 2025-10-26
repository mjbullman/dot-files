-- =======================
--  Neo-tree Configuration
--  Author: Martin Bullman
-- =======================

require("neo-tree").setup({
	popup_border_style = "",
	close_if_last_window = true,
	windew = {
		width = 35,
		-- mappings = {},
		position = "left",
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	default_component_configs = {
		indent = {
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		git_status = {
			symbols = {
				unstaged = "󰄱",
				staged = "󰱒",
			},
		},
	},
})

-- =========================================================
-- Neo-tree Keymaps
-- =========================================================

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Toggle Neo-tree at project root (cwd).
map("n", "<leader>e", function()
	require("neo-tree.command").execute({
		dir = vim.loop.cwd(),
		toggle = true,
		source = "filesystem",
		position = "left",
	})
end, vim.tbl_extend("force", opts, { desc = "Toggle Neo-tree (cwd)" }))

-- Toggle Neo-tree in the current working directory.
map("n", "<leader>E", function()
	require("neo-tree.command").execute({
		dir = vim.loop.cwd(),
		toggle = true,
		reveal = true,
		position = "left",
	})
end, vim.tbl_extend("force", opts, { desc = "Toggle Neo-tree" }))
