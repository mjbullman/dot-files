-- =======================
-- Neo-tree Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
        require("config.neotree")
    end
}

