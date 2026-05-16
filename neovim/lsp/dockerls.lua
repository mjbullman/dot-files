-- ==============================
-- Docker LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/docker-langserver', '--stdio' },
    root_markers = { 'Dockerfile', 'docker-compose.yml', 'docker-compose.yaml', '.dockerignore' },
    filetypes = { 'dockerfile' },
}
