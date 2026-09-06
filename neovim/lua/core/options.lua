-- =============================
-- Core Neovim Setup Options
-- Author: Martin Bullman
-- =============================

-- set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- disable line wrapping
vim.opt.wrap = false

-- show line numbers
vim.opt.number = true
-- set relative line numbers
vim.opt.relativenumber = false

-- use spaces instead of tabs
vim.opt.expandtab = true
-- size of spaces for tabs
vim.opt.tabstop = 4
-- size for spaces using << and >>
vim.opt.shiftwidth = 4
-- how many spaces when pressing tab
vim.opt.softtabstop = 4

vim.opt.winborder = "rounded"

-- enable mouse support
vim.opt.mouse = 'a'

-- sync clipboard between OS and Neovim
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- enable break indent
vim.opt.breakindent = true

-- save undo history to file
vim.opt.undofile = true

-- case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- folding via treesitter
vim.opt.foldcolumn = '1'
vim.opt.foldlevel  = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.fillchars  = {
    foldopen = '▾',
    foldclose = '▸',
    fold = ' ',
    foldsep = ' '
}

-- decrease update time
vim.opt.updatetime = 250
-- decrease mapped sequence timeout
vim.opt.timeoutlen = 300

-- controls how new window splits open
vim.opt.splitright = true
vim.opt.splitbelow = true

-- indentation options
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- controls how whitespace is shown
vim.opt.list = true
vim.opt.listchars = { tab = '>>', trail = '·', nbsp = '␣' }

-- preview search substitution live
vim.opt.inccommand = 'split'

-- show line cursor is on
vim.opt.cursorline = true

-- minimum number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10
-- minimum number of screen columns to keep left and right of the cursor
vim.opt.sidescrolloff = 8

-- show popup when unsaved files
vim.opt.confirm = true

-- enable 24-bit RGB colors
vim.opt.termguicolors = true

-- native completion only (<C-x><C-o>); blink.cmp draws its own menu
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.pumheight = 12

-- reclaim the command-line row: noice renders ':' and '/' as popups, so the
-- native cmdline is only needed transiently. 0 lets lualine's global
-- statusline sit flush against the bottom of the window.
vim.opt.cmdheight = 0

-- lualine already shows the mode; the native "-- INSERT --" has nowhere to go
-- with cmdheight = 0 and would force a transient row
vim.opt.showmode = false


-- -----------------------------
-- highlight yanked text
-- -----------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', {}),
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 200,
        })
    end,
})
