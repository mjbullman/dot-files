-- =======================
--  Comment Plugin Setup
--  Author: Martin Bullman
-- =======================

return {
    'numToStr/Comment.nvim',
    config = function()
        require('config.comment')
    end
}
