-- =======================
-- Telescope Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("config.telescope")

        -- -----------------------------
        -- Custom Keymaps for Telescope
        -- -------------------------------
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, {
            desc = "Telescope: Find Files",
        })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
            desc = "Telescope: Live Grep",
        })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
            desc = "Telescope: Help Tags",
        })
        vim.keymap.set("n", "<leader><leader>", builtin.buffers, {
            desc = "Telescope: Find Buffers",
        })
        vim.keymap.set("n", "<leader>f.", builtin.oldfiles, {
            desc = "Telescope: Recent Files",
        })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {
            desc = "[S]earch [D]iagnostics",
        })
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, {
            desc = "[S]earch [K]eymaps",
        })
    end
}
