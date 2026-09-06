require('catppuccin').setup({
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    background = {
        light = 'latte',
        dark = 'mocha',
    },
    transparent_background = false, -- disables setting the background color.
    float = {
    --    transparent = false, -- enable transparent floating windows
    --    solid = false, -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    --dim_inactive = {
    --    enabled = false, -- dims the background color of inactive window
    --   shade = 'dark',
    --    percentage = 0.15, -- percentage of the shade to apply to the inactive window
    --},
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    --styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    --    comments = { 'italic' }, -- Change the style of comments
    --    conditionals = { 'italic' },
    --    loops = {},
    --    functions = {},
    --    keywords = {},
    --    strings = {},
    --    variables = {},
    --    numbers = {},
    --    booleans = {},
    --    properties = {},
    --    types = {},
    --    operators = {},
    --    miscs = {}, -- Uncomment to turn off hard-coded styles
    --},
    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
        },
        underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
        },
        inlay_hints = {
            background = true,
        },
    },
    --color_overrides = {},
    custom_highlights = function(colors)
        -- Shared git / diagnostic accents (Catppuccin Latte hues on the Mocha
        -- background). Defined once in core/palette.lua so the neo-tree tree,
        -- the gitsigns gutter, bufferline, lualine and the diagnostic signs
        -- cannot drift apart.
        local palette = require('core.palette')
        local git = palette.git
        local diag = palette.diag

        return {
            TroubleNormal   = { bg = colors.mantle },
            TroubleNormalNC = { bg = colors.mantle },

            -- neo-tree file tree
            NeoTreeGitAdded     = { fg = git.add },
            NeoTreeGitModified  = { fg = git.change },
            NeoTreeGitRenamed   = { fg = git.rename },
            NeoTreeGitDeleted   = { fg = colors.overlay1, strikethrough = true },
            NeoTreeGitConflict  = { fg = git.delete },
            NeoTreeGitUntracked = { fg = git.special },
            NeoTreeGitStaged    = { fg = git.add },
            NeoTreeGitIgnored   = { fg = colors.overlay0 },

            -- buffer-unsaved dot in the tree: same hue as the bufferline and
            -- lualine unsaved indicators (git "change" peach)
            NeoTreeModified = { fg = git.change },

            -- indent guides sit one step below the default (overlay0) so the
            -- tree structure recedes and the file icons carry the eye
            NeoTreeIndentMarker = { fg = colors.surface1 },
            NeoTreeExpander     = { fg = colors.surface1 },

            -- gitsigns gutter
            GitSignsAdd          = { fg = git.add },
            GitSignsChange       = { fg = git.change },
            GitSignsDelete       = { fg = git.delete },
            GitSignsTopdelete    = { fg = git.delete },
            GitSignsChangedelete = { fg = git.special },
            GitSignsUntracked    = { fg = git.special },

            -- diagnostics: the base severity groups drive the sign icons, the
            -- tiny-inline-diagnostic bars, the lualine count and neo-tree's
            -- fallback. Underline and float keep the Catppuccin palette.
            DiagnosticError = { fg = diag.error },
            DiagnosticWarn  = { fg = diag.warn },
            DiagnosticInfo  = { fg = diag.info },
            DiagnosticHint  = { fg = diag.hint },

            DiagnosticSignError = { fg = diag.error },
            DiagnosticSignWarn  = { fg = diag.warn },
            DiagnosticSignInfo  = { fg = diag.info },
            DiagnosticSignHint  = { fg = diag.hint },

            DiagnosticUnderlineError = { sp = diag.error, underline = true },
            DiagnosticUnderlineWarn  = { sp = diag.warn, underline = true },
            DiagnosticUnderlineInfo  = { sp = diag.info, underline = true },
            DiagnosticUnderlineHint  = { sp = diag.hint, underline = true },

            -- noice links its cmdline chrome to DiagnosticSign*, which would
            -- drag the Latte blue/orange onto the popup border. The ':' cmdline
            -- shares the telescope prompt's mauve; search uses the same peach as
            -- lazygit's searching border (config.yml); confirm stays on sky.
            NoiceCmdlinePopupBorder       = { fg = colors.mauve },
            NoiceCmdlinePopupTitle        = { fg = colors.mauve },
            NoiceCmdlineIcon              = { fg = colors.mauve },
            NoiceConfirmBorder            = { fg = colors.sky },
            NoiceCmdlinePopupBorderSearch = { fg = colors.peach },
            NoiceCmdlineIconSearch        = { fg = colors.peach },

            -- telescope prompt magnifier glyph, same mauve as the ':' cmdline
            TelescopePromptPrefix = { fg = colors.mauve },
        }
    end,
    default_integrations = true,
    auto_integrations = true,
    integrations = {
        cmp = true,
        notify = false,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
        lsp_trouble = true,
        bufferline = { enabled = false },
        treesitter = true,
        mini = {
            enabled = true,
            indentscope_color = '',
        },
    },
})

-- setup must be called before loading
vim.cmd.colorscheme 'catppuccin'
