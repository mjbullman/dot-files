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
        -- Shared git status palette: Catppuccin's Latte (light) accents are
        -- deeper, more saturated versions of the same hues and read more
        -- clearly on the Mocha background than the Mocha pastels do. Used by
        -- both the neo-tree file tree and the gitsigns gutter so the two match.
        local latte = require('catppuccin.palettes').get_palette('latte')
        local git = {
            add     = latte.green,  -- #40a02b
            change  = latte.peach,  -- #fe640b
            delete  = latte.red,    -- #d20f39
            rename  = latte.blue,   -- #1e66f5
            special = latte.maroon, -- #e64553  untracked / changedelete
        }

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

            -- gitsigns gutter
            GitSignsAdd          = { fg = git.add },
            GitSignsChange       = { fg = git.change },
            GitSignsDelete       = { fg = git.delete },
            GitSignsTopdelete    = { fg = git.delete },
            GitSignsChangedelete = { fg = git.special },
            GitSignsUntracked    = { fg = git.special },
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
