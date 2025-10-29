-- ===============================
-- Telescope Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local builtin = require("telescope/builtin")

-- -----------------------------
-- Custom Keymaps for Telescope
-- -------------------------------
vim.keymap.set("n", "<leader>ff", builtin.find_files, {
	desc = "Telescope: Find Files",
})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
	desc = "Telescope: Live Grep",
})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {
	desc = "Telescope: Find Buffers",
})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
	desc = "Telescope: Help Tags",
})

