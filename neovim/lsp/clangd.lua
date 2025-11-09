-- ==============================
-- C LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { "clangd", "--background-index" },
    root_markers = { "compile_commands.json", "compile_flags.txt" },
    filetypes = { "c", "cpp" },
}
