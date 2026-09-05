-- ===============================
-- DAP (Debugger) Configuration
-- Author: Martin Bullman
-- ===============================

local dap = require('dap')
local dapui = require('dapui')

-- Setup DAP UI
require('dapui').setup()

-- Setup virtual text for DAP
require('nvim-dap-virtual-text').setup({})

-- =============================
-- Breakpoint signs
-- =============================
-- Material Design, same family as the diagnostic signs in config/lsp.lua, but
-- distinct glyphs so a breakpoint is never mistaken for a diagnostic sharing
-- the same sign column.
vim.fn.sign_define('DapBreakpoint', { text = '󰝥', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '󰋗', texthl = 'DapBreakpointCondition' })
vim.fn.sign_define('DapLogPoint', { text = '󰎞', texthl = 'DapLogPoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = '󰂭', texthl = 'DapBreakpointRejected' })
vim.fn.sign_define('DapStopped', { text = '󰐌', texthl = 'DapStopped' })

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
-- JavaScript / TypeScript / Vue
-- =============================

local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'

-- one js-debug binary serves both adapters; ${port} lets nvim pick a free port
for _, adapter in ipairs({ 'pwa-node', 'pwa-chrome' }) do
    dap.adapters[adapter] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
            command = mason_bin .. '/js-debug-adapter',
            args = { '${port}' },
        },
    }
end

local js_configurations = {
    {
        type = 'pwa-node',
        request = 'launch',
        name = 'Vitest: current file',
        runtimeExecutable = 'npx',
        runtimeArgs = { 'vitest', 'run', '--no-coverage', '${file}' },
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        sourceMaps = true,
        skipFiles = { '<node_internals>/**', '**/node_modules/**' },
    },
    {
        -- requires the dev server started with: nuxt dev --inspect
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to Nuxt dev server (SSR / server routes)',
        port = 9229,
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        restart = true,
        skipFiles = { '<node_internals>/**', '**/node_modules/**' },
    },
    {
        -- requires chrome started with: --remote-debugging-port=9222
        -- sourceMapPathOverrides is the fiddly part: Nuxt serves through a virtual
        -- filesystem, so browser URLs need mapping back to real files. Tune if
        -- breakpoints in .vue files show as unbound.
        type = 'pwa-chrome',
        request = 'attach',
        name = 'Attach to Chrome (client)',
        port = 9222,
        webRoot = '${workspaceFolder}',
        sourceMaps = true,
        sourceMapPathOverrides = {
            ['./*'] = '${webRoot}/*',
            ['../*'] = '${webRoot}/*',
            ['/_nuxt/*'] = '${webRoot}/*',
        },
    },
}

for _, ft in ipairs({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue' }) do
    dap.configurations[ft] = js_configurations
end

-- =============================
-- Python
-- =============================

-- Mason's debugpy-adapter shim hosts the adapter, so nothing needs debugpy in
-- the project venv. The *debuggee* interpreter is resolved separately by
-- dap-python (VIRTUAL_ENV, then a venv/.venv/env/.env directory under the
-- project root), and an explicit `python` on a config wins over both — which is
-- how neotest-python's <leader>nd hands over each project's own .venv.
require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/bin/debugpy-adapter')

-- match config/neotest.lua rather than letting dap-python sniff the project
require('dap-python').test_runner = 'pytest'


-- =============================
-- Language-agnostic dispatch
-- =============================

-- One set of <leader>d* keys for every language. Each ecosystem needs a different
-- mechanism to resolve "the test under the cursor", so dispatch on filetype rather
-- than giving each language its own bindings.

local M = {}

local function unsupported(action)
    vim.notify(
        ('No %s runner for filetype: %s'):format(action, vim.bo.filetype),
        vim.log.levels.WARN
    )
end

local function is_js(ft)
    return vim.tbl_contains(
        { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue' },
        ft
    )
end

function M.debug_nearest_test()
    local ft = vim.bo.filetype
    if ft == 'java' then
        require('jdtls').test_nearest_method()
    elseif ft == 'python' then
        require('dap-python').test_method()
    elseif is_js(ft) then
        -- vitest resolves the nearest test itself when given the file
        dap.run(js_configurations[1])
    else
        unsupported('test')
    end
end

function M.debug_test_class()
    local ft = vim.bo.filetype
    if ft == 'java' then
        require('jdtls').test_class()
    elseif ft == 'python' then
        require('dap-python').test_class()
    elseif is_js(ft) then
        dap.run(js_configurations[1])
    else
        unsupported('test')
    end
end

-- Java main-class configs are resolved lazily: doing it on every LspAttach fires
-- java-debug's resolveJavaExecutable per file open, which crashes adapter 0.53.2.
-- Register once per project on first continue instead.
local java_main_registered = {}

function M.continue()
    if vim.bo.filetype == 'java' then
        local root = vim.fn.getcwd()
        if not java_main_registered[root] then
            java_main_registered[root] = true
            require('jdtls.dap').setup_dap_main_class_configs()
            -- resolution is async; give jdtls a moment before offering configs
            vim.defer_fn(function()
                dap.continue()
            end, 1000)
            return
        end
    end
    dap.continue()
end

return M
