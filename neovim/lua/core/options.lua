-- =============================
-- Core Neovim Setup Options
-- Author: Martin Bullman
-- =============================

-- set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

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

-- enable mouse support
vim.opt.mouse = 'a'

-- sync clipboard between OS and Neovim
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- enable break indent
vim.opt.breakindent = true
-- enable smart indent
vim.opt.smartindent = false

-- save undo history to file
vim.opt.undofile = true

-- case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- keep sign column on by default
vim.opt.signcolumn = 'yes'

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
vim.o.scrolloff = 10
-- minimum number of screen columns to keep left and right of the cursor
vim.opt.sidescrolloff = 8

-- show popup when unsaved files
vim.opt.confirm = true

-- enable 24-bit RGB colors
vim.opt.termguicolors = true


-- -----------------------------
-- Highlight yanked text
-- -----------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', {}),
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 200,
        })
    end,
})

