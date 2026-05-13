local c = require('catppuccin.palettes').get_palette('mocha')

require('bufferline').setup({
    highlights = {
        fill = {
            bg = c.base,
        },
        background = {
            fg = c.overlay0,
            bg = c.mantle,
        },
        buffer_selected = {
            fg = c.text,
            bg = c.surface0,
            bold = true,
        },
        buffer_visible = {
            fg = c.overlay0,
            bg = c.mantle,
        },
        separator = {
            fg = c.base,
            bg = c.mantle,
        },
        separator_selected = {
            fg = c.base,
            bg = c.surface0,
        },
        separator_visible = {
            fg = c.base,
            bg = c.mantle,
        },
        tab = {
            fg = c.overlay0,
            bg = c.mantle,
        },
        tab_selected = {
            fg = c.text,
            bg = c.surface1,
            bold = true,
        },
        offset_separator = {
            fg = c.base,
            bg = c.base,
        },
        tab_close = {
            fg = c.red,
            bg = c.base,
        },
        close_button = {
            fg = c.overlay0,
            bg = c.mantle,
        },
        close_button_selected = {
            fg = c.red,
            bg = c.surface0,
        },
        modified = {
            fg = c.peach,
            bg = c.mantle,
        },
        modified_selected = {
            fg = c.peach,
            bg = c.surface0,
        },
    },
    options = {
        mode = 'buffers',
        separator_style = 'slant',
        numbers = 'none',
        sort_by = 'insert_after_current',
        close_command = function(bufnum) Snacks.bufdelete(bufnum) end,
        right_mouse_command = function(bufnum) Snacks.bufdelete(bufnum) end,
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        indicator = {
            icon = '▎',
            style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = ' ',
        left_trunc_marker = ' ',
        right_trunc_marker = ' ',
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        color_icons = true,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_update_on_event = true,
        diagnostics_indicator = function(count, level)
            local icons = { error = ' ', warning = ' ', info = ' ', hint = '󰌵 ' }
            return (icons[level] or '') .. count
        end,
        offsets = {
            {
                filetype = 'neo-tree',
                text = 'File Explorer',
                text_align = 'center',
                separator = true,
            },
        },
        hover = {
            enabled = true,
            delay = 150,
            reveal = { 'close' },
        },
    },
})
