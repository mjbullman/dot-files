-- =============================
-- Vue JS LSP Config
-- Author: Martin Bullman
-- =============================

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vue-language-server', '--stdio' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
    filetypes = { 'vue' },

    on_init = function(client)
        local retries = 0

        local function typescriptHandler(_, result, context)
            local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]

            -- vtsls may not have attached yet — retry up to 10 times at 100ms intervals
            if not ts_client then
                if retries <= 10 then
                    retries = retries + 1
                    vim.defer_fn(function()
                        typescriptHandler(_, result, context)
                    end, 100)
                else
                    vim.notify('[vue_ls] Could not find vtsls client', vim.log.levels.ERROR)
                end
                return
            end

            local param = unpack(result)
            local id, command, payload = unpack(param)

            ts_client:exec_cmd({
                title = 'vue_request_forward',
                command = 'typescript.tsserverRequest',
                arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
                client:notify('tsserver/response', { { id, r and r.body } })
            end)
        end

        client.handlers['tsserver/request'] = typescriptHandler
    end,
}
