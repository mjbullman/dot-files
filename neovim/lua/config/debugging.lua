-- ===============================
-- DAP (Debugger) Configuration
-- Author: Martin Bullman
-- ===============================

local dap = require("dap")
local dapui = require("dapui")

-- Setup DAP UI
require("dapui").setup()

-- Setup DAP for Go
require("dap-go").setup()

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

-- =============================
-- DAP Keymaps
-- =============================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>dt", dap.toggle_breakpoint, vim.tbl_extend("force", opts, {
    desc = "Debug: Toggle breakpoint"
}))
map("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, {
    desc = "Debug: Continue"
}))
map("n", "<leader>ds", dap.step_over, vim.tbl_extend("force", opts, {
    desc = "Debug: Step over"
}))
map("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, {
    desc = "Debug: Step into"
}))
map("n", "<leader>do", dap.step_out, vim.tbl_extend("force", opts, {
    desc = "Debug: Step out"
}))
map("n", "<leader>dr", dap.repl.open, vim.tbl_extend("force", opts, {
    desc = "Debug: Open REPL"
}))
map("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, {
    desc = "Debug: Toggle UI"
}))
