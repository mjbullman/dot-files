-- =======================
--  Kulala Plugin Setup
--  REST client for .http files
--  Author: Martin Bullman
-- =======================

return {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    -- kulala registers its own keymaps (global_keymaps in config/kulala.lua).
    -- These entries exist only so the plugin loads when one is pressed outside an
    -- .http buffer; kulala replaces them with the real mappings on load.
    keys = {
        { '<leader>R', '', desc = 'REST (kulala)' },
        { '<leader>Rs', function() require('kulala').run() end, mode = { 'n', 'v' }, desc = 'Send request' },
        { '<leader>Ra', function() require('kulala').run_all() end, mode = { 'n', 'v' }, desc = 'Send all requests' },
        { '<leader>Rr', function() require('kulala').replay() end, desc = 'Replay last request' },
        { '<leader>Rb', function() require('kulala').scratchpad() end, desc = 'Open scratchpad' },
        { '<leader>Ro', function() require('kulala').open() end, desc = 'Open kulala' },
    },
    config = function()
        require('config.kulala')
    end,
}
