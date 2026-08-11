-- =======================
--  SchemaStore Plugin Setup
--  JSON schema catalogue for jsonls
--  Author: Martin Bullman
-- =======================

return {
    'b0o/schemastore.nvim',
    -- no events or keys: loaded on demand by the require() in lsp/jsonls.lua,
    -- which lazy.nvim intercepts when the JSON server starts.
    lazy = true,
}
