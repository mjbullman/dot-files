-- =======================
-- None-LS Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
	"nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },	
    config = function()
		require("config.nonels")
	end,
}
