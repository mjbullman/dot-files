-- ===============================
-- Neotest Configuration
-- Author: Martin Bullman
-- ===============================

local neotest = require('neotest')

neotest.setup({
    adapters = {
        require('neotest-java'),
    },
    icons = {
        passed = '✓',
        failed = '✗',
        running = '⟳',
        skipped = '○',
        unknown = '?',
    },
    status = {
        virtual_text = true,
        signs = true,
    },
    output = {
        open_on_run = false,
    },
    quickfix = {
        open = false,
    },
})

-- =============================
-- Neotest Keymaps
-- =============================
local map = vim.keymap.set

map('n', '<leader>nr', function() neotest.run.run() end, { desc = 'Run nearest test' })
map('n', '<leader>nf', function() neotest.run.run(vim.fn.expand('%')) end, { desc = 'Run test file' })
map('n', '<leader>nd', function() neotest.run.run({ strategy = 'dap' }) end, { desc = 'Debug nearest test' })
map('n', '<leader>ns', function() neotest.run.stop() end, { desc = 'Stop test' })
map('n', '<leader>no', function() neotest.output.open({ enter = true }) end, { desc = 'Show test output' })
map('n', '<leader>np', function() neotest.output_panel.toggle() end, { desc = 'Toggle output panel' })
map('n', '<leader>nm', function() neotest.summary.toggle() end, { desc = 'Toggle test summary' })
map('n', '[n', function() neotest.jump.prev({ status = 'failed' }) end, { desc = 'Previous failed test' })
map('n', ']n', function() neotest.jump.next({ status = 'failed' }) end, { desc = 'Next failed test' })
