-- ==============================
-- C LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        'clangd',
        '--background-index',
        '--all-scopes-completion',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
        '--cross-file-rename',
    },
    root_markers = {
        'compile_commands.json',
        'compile_flags.txt',
    },
    filetypes = {
        'c',
        'cpp',
    },
}
