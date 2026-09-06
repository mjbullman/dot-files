-- =======================
--  Lualine Configuration
--  Author: Martin Bullman
-- =======================

-- Shared git accents (see lua/core/palette.lua) so the diff counts match the
-- gitsigns gutter and neo-tree rather than the stock lualine theme's pastels.
local git = require('core.palette').git

require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'catppuccin-mocha',
        component_separators = {
            left = '',
            right = '',
        },
        section_separators = {
            left = '',
            right = '',
        },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                'WinEnter',
                'BufEnter',
                'BufWritePost',
                'SessionLoadPost',
                'FileChangedShellPost',
                'VimResized',
                'Filetype',
                'ModeChanged',
            },
        },
    },
    sections = {
        lualine_a = {
            'mode',
        },
        lualine_b = {
            'branch',
            {
                'diff',
                -- pull hunk counts straight from gitsigns instead of shelling out to git
                source = function()
                    local gs = vim.b.gitsigns_status_dict
                    if gs then
                        return { added = gs.added, modified = gs.changed, removed = gs.removed }
                    end
                end,
                -- pin to the shared git palette, not the lualine theme's pastels
                diff_color = {
                    added = { fg = git.add },
                    modified = { fg = git.change },
                    removed = { fg = git.delete },
                },
            },
            {
                'diagnostics',
                -- same glyphs as the gutter signs in config/lsp.lua
                symbols = {
                    error = '󰅙 ',
                    warn = '󰀦 ',
                    info = '󰋼 ',
                    hint = '󰛨 '
                },
            },
        },
        lualine_c = {
            {
                'filename',
                path = 1, -- relative to cwd
                symbols = {
                    modified = ' ●', -- same unsaved-buffer dot as bufferline / neo-tree
                    readonly = ' ',
                    newfile = ' ',
                },
            },
        },
        lualine_x = {
            {
                -- LSP servers attached to the current buffer, by name
                function()
                    local names = {}
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                        names[#names + 1] = client.name
                    end
                    return #names > 0 and (' ' .. table.concat(names, ', ')) or ''
                end,
            },
            {
                -- only when it isn't the usual utf-8
                'encoding',
                cond = function()
                    return vim.bo.fileencoding ~= '' and vim.bo.fileencoding ~= 'utf-8'
                end,
            },
            {
                -- only when line endings aren't unix (LF)
                'fileformat',
                cond = function()
                    return vim.bo.fileformat ~= 'unix'
                end,
            },
            'filetype',
        },
        lualine_y = {
            'selectioncount', -- only visible in Visual mode
            'searchcount',    -- only visible while a search is active
            'progress',
        },
        lualine_z = {
            'location',
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            'filename',
        },
        lualine_x = {
            'location',
        },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {},
})
