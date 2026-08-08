-- ==============================
-- Docker LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/docker-language-server',
        'start',
        '--stdio',
    },
    filetypes = { 'dockerfile', 'yaml.docker-compose' },
    root_markers = { 'Dockerfile', 'compose.yaml', 'docker-compose.yaml', '.git' },
}
