-- ===============================
-- GitHub Copilot Configuration
-- Author: Martin Bullman
-- ===============================

-- disable Copilot by default (manual control)
vim.g.copilot_enabled = false

-- don't auto-trigger on every keystroke
vim.g.copilot_no_tab_map = true

-- only suggest on specific filetypes
vim.g.copilot_filetypes = {
	['*'] = true,
	['TelescopePrompt'] = false,
	['chatgpt-input'] = false,
	['chatgpt'] = false,
}

-- =============================
-- Copilot Keymaps (Manual Control)
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- toggle Copilot on/off
map('n', '<leader>cp', function()
	if vim.g.copilot_enabled then
		vim.cmd('Copilot disable')
		vim.g.copilot_enabled = false
		print('Copilot disabled')
	else
		vim.cmd('Copilot enable')
		vim.g.copilot_enabled = true
		print('Copilot enabled')
	end
end, vim.tbl_extend('force', opts, {
	desc = 'Copilot: Toggle on/off'
}))
map('i', '<C-\\>', '<Plug>(copilot-suggest)', {
	desc = 'Copilot: Trigger suggestion'
})
map('i', '<C-j>', '<Plug>(copilot-accept-word)', {
	desc = 'Copilot: Accept word'
})
map('i', '<C-l>', '<Plug>(copilot-accept-line)', {
	desc = 'Copilot: Accept line'
})
map('i', '<M-]>', '<Plug>(copilot-next)', {
	desc = 'Copilot: Next suggestion'
})
map('i', '<M-[>', '<Plug>(copilot-previous)', {
	desc = 'Copilot: Previous suggestion'
})
-- Dismiss suggestion (Esc works naturally)
map('i', '<C-x>', '<Plug>(copilot-dismiss)', {
	desc = 'Copilot: Dismiss suggestion'
})
