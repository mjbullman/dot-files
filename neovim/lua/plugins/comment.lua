-- =======================
--  Comment Plugin Setup
--  Author: Martin Bullman
-- =======================

return {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
        require("config.comment")
    end
}
