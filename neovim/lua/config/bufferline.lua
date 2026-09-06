local c = require('catppuccin.palettes').get_palette('mocha')

-- Diagnostic severity hues: Catppuccin Latte accents, matching the diagnostic
-- signs and the git colours set in lua/config/catppuccin.lua.
local latte = require('catppuccin.palettes').get_palette('latte')
local diag = {
    error = latte.red,   -- #d20f39  (= git conflict/delete)
    warn  = latte.peach, -- #fe640b  (= git modified)
    info  = latte.blue,  -- #1e66f5  (= git renamed)
    hint  = latte.teal,  -- #179299  (diagnostic-only hue)
}

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
            fg = latte.red,
            bg = c.base,
        },
        close_button = {
            fg = c.overlay0,
            bg = c.mantle,
        },
        close_button_selected = {
            fg = latte.red,
            bg = c.surface0,
        },
        -- the ● unsaved-buffer dot: tie it to the git "modified" orange.
        -- all three states, or modified_visible falls back to String green.
        modified = {
            fg = latte.peach,
            bg = c.mantle,
        },
        modified_visible = {
            fg = latte.peach,
            bg = c.mantle,
        },
        modified_selected = {
            fg = latte.peach,
            bg = c.surface0,
        },

        -- diagnostic states: keep the same tab background but tint the text
        -- with the diagnostic severity colour so the tab doesn't shift hue
        error = {
            fg = diag.error,
            bg = c.mantle,
            sp = diag.error,
        },
        error_visible = {
            fg = diag.error,
            bg = c.mantle,
        },
        error_selected = {
            fg = diag.error,
            bg = c.surface0,
            bold = true,
            italic = false,
        },
        error_diagnostic = {
            fg = diag.error,
            bg = c.mantle,
            sp = diag.error,
        },
        error_diagnostic_visible = {
            fg = diag.error,
            bg = c.mantle,
        },
        error_diagnostic_selected = {
            fg = diag.error,
            bg = c.surface0,
            bold = true,
            italic = false,
        },

        warning = {
            fg = diag.warn,
            bg = c.mantle,
            sp = diag.warn,
        },
        warning_visible = {
            fg = diag.warn,
            bg = c.mantle,
        },
        warning_selected = {
            fg = diag.warn,
            bg = c.surface0,
            bold = true,
            italic = false,
        },
        warning_diagnostic = {
            fg = diag.warn,
            bg = c.mantle,
            sp = diag.warn,
        },
        warning_diagnostic_visible = {
            fg = diag.warn,
            bg = c.mantle,
        },
        warning_diagnostic_selected = {
            fg = diag.warn,
            bg = c.surface0,
            bold = true,
            italic = false,
        },

        info = {
            fg = diag.info,
            bg = c.mantle,
            sp = diag.info,
        },
        info_visible = {
            fg = diag.info,
            bg = c.mantle,
        },
        info_selected = {
            fg = diag.info,
            bg = c.surface0,
            bold = true,
            italic = false,
        },
        info_diagnostic = {
            fg = diag.info,
            bg = c.mantle,
            sp = diag.info,
        },
        info_diagnostic_visible = {
            fg = diag.info,
            bg = c.mantle,
        },
        info_diagnostic_selected = {
            fg = diag.info,
            bg = c.surface0,
            bold = true,
            italic = false,
        },

        hint = {
            fg = diag.hint,
            bg = c.mantle,
            sp = diag.hint,
        },
        hint_visible = {
            fg = diag.hint,
            bg = c.mantle,
        },
        hint_selected = {
            fg = diag.hint,
            bg = c.surface0,
            bold = true,
            italic = false,
        },
        hint_diagnostic = {
            fg = diag.hint,
            bg = c.mantle,
            sp = diag.hint,
        },
        hint_diagnostic_visible = {
            fg = diag.hint,
            bg = c.mantle,
        },
        hint_diagnostic_selected = {
            fg = diag.hint,
            bg = c.surface0,
            bold = true,
            italic = false,
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
            -- same glyphs as the gutter signs in config/lsp.lua
            local icons = {
                error = '󰅙 ',
                warning = '󰀦 ',
                info = '󰋼 ',
                hint = '󰛨 '
            }
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
