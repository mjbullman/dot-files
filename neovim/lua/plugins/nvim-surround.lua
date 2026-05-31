-- =======================
-- nvim-surround Plugin Setup
-- Author: Martin Bullman
-- =======================
--
-- Add/change/delete surrounding pairs:
--   ysiw"     wrap word in double quotes
--   cs"'      change " to '
--   ds"       delete surrounding "
--   S<char>   in visual mode, surround selection

return {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
}
