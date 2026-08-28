-- =======================
--  Diffview Plugin Setup
--  Whole-branch review and merge conflict resolution
--  Author: Martin Bullman
-- =======================

-- The default branch is main here but master elsewhere; ask git rather than
-- hardcoding, and fall back to main when there is no origin/HEAD to read.
local function default_branch()
    local ref = vim.fn.systemlist('git symbolic-ref --short refs/remotes/origin/HEAD')[1]
    if vim.v.shell_error == 0 and ref then
        return (ref:gsub('^origin/', ''))
    end
    return 'main'
end

return {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
    -- keymaps belong here, not in config: with cmd-only lazy loading the config
    -- body never runs until a command is typed, so keys defined there never exist.
    keys = {
        {
            '<leader>gd',
            function()
                -- three dots: everything on this branch since it diverged from the
                -- default branch, the same range a pull request shows
                vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD')
            end,
            desc = 'Review branch against default',
        },
        { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history (current file)' },
        { '<leader>gH', '<cmd>DiffviewFileHistory<cr>',   desc = 'File history (repo)' },
    },
    config = function()
        require('config.diffview')
    end,
}
