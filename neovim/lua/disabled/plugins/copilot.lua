-- =======================
-- GitHub Copilot Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'github/copilot.vim',
    config = function()
        require('config.copilot')
    end,
}
