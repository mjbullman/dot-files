-- ===============================
-- DAP (Debugger) Configuration
-- Author: Martin Bullman
-- ===============================

local dap = require('dap')
local dapui = require('dapui')

-- Setup DAP UI
require('dapui').setup()

-- Setup DAP for Go
require('dap-go').setup()

-- Setup virtual text for DAP
require('nvim-dap-virtual-text').setup()

-- DAP UI auto-open/close listeners
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- keymaps live in plugins/debugging.lua so they work before the plugin loads
