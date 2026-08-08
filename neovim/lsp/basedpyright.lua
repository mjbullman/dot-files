-- ==============================
-- Python LSP Config
-- Author: Martin Bullman
-- ==============================

-- basedpyright already auto-detects .venv/venv sitting at its root_dir, so only
-- fill in pythonPath for the cases it cannot find on its own: an activated venv,
-- or a venv in a subdirectory below the root (common when root_dir anchors to
-- the git root but the venv lives beside the app).
-- Deliberately no system-python fallback: guessing wrong here would override
-- basedpyright's own working detection.
local function find_python(root, start)
    -- an already-activated venv wins: it is what the shell/tests are using
    local active = vim.env.VIRTUAL_ENV
    if active and active ~= '' then
        local p = active .. '/bin/python'
        if vim.fn.executable(p) == 1 then
            return p
        end
    end

    -- walk up from the file towards the root looking for a venv
    local dir = start
    while dir and dir ~= '' do
        for _, name in ipairs({ '.venv', 'venv', 'env' }) do
            local p = dir .. '/' .. name .. '/bin/python'
            if vim.fn.executable(p) == 1 then
                return p
            end
        end
        if root and dir == root then
            break
        end
        local parent = vim.fn.fnamemodify(dir, ':h')
        if parent == dir then
            break
        end
        dir = parent
    end

    return nil
end

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/basedpyright-langserver', '--stdio'
    },
    filetypes = { 'python' },
    before_init = function(_, config)
        local python = find_python(
            config.root_dir,
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
        )
        if python then
            config.settings = config.settings or {}
            config.settings.python = vim.tbl_deep_extend(
                'force',
                config.settings.python or {},
                { pythonPath = python }
            )
        end
    end,
    root_markers = {
        '.git',
        'pyrightconfig.json',
        'setup.py',
        'setup.cfg',
        'pyproject.toml',
        'requirements.txt',
    },
    settings = {
        basedpyright = {
            analysis = {
                diagnosticMode = 'openFilesOnly', -- only check files you have open
                autoSearchPaths = true,
                typeCheckingMode = 'basic', -- 'off', 'basic', 'standard', or 'strict'
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                indexing = true,
            },
            disableOrganizeImports = false,
            disableLanguageServices = false,
        },
    },
    on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
}
