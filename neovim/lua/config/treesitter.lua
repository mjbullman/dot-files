-- ===============================
-- Treesitter Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local ts = require('nvim-treesitter')

-- Install parsers that aren't already installed
local ensure_installed = {
    'lua',
    'css',
    'vue',
    'php',
    'html',
    'scss',
    'json',
    'bash',
    'rust',
    'regex',
    'javascript',
    'typescript',
}

for _, lang in ipairs(ensure_installed) do
    if not ts.is_installed(lang) then
        ts.install(lang)
    end
end

-- Enable highlighting and indentation via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype

        pcall(vim.treesitter.start, bufnr)

        -- Disable treesitter indentation for Vue (known issues)
        if ft ~= 'vue' then
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
