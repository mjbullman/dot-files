-- =======================
--  Comment Configuration
--  Author: Martin Bullman
-- =======================

require('Comment').setup({
    -- context-aware commentstring: a toggle inside a Vue <template> or a
    -- JSX block picks <!-- --> / {/* */} instead of the file's top-level
    -- comment syntax. Everything else is left at Comment.nvim defaults.
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
