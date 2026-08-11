-- =======================
-- DAP Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'theHamsta/nvim-dap-virtual-text',
    },
    -- keys live here so they exist before the plugin loads
    keys = {
        { '<leader>dt', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle breakpoint' },
        { '<leader>dc', function() require('dap').continue() end,          desc = 'Debug: Continue' },
        { '<leader>ds', function() require('dap').step_over() end,         desc = 'Debug: Step over' },
        { '<leader>di', function() require('dap').step_into() end,         desc = 'Debug: Step into' },
        { '<leader>do', function() require('dap').step_out() end,          desc = 'Debug: Step out' },
        { '<leader>dr', function() require('dap').repl.open() end,         desc = 'Debug: Open REPL' },
        { '<leader>du', function() require('dapui').toggle() end,          desc = 'Debug: Toggle UI' },
    },
    config = function()
        require('config.debugging')
    end,
}
