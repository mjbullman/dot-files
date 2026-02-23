-- =============================
-- Vue JS LSP Config
-- Author: Martin Bullman
-- =============================

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vue-language-server', '--stdio' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
    filetypes = { 'vue' },

    on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
            local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })

            if #vtsls_clients == 0 then
                vim.notify('Could not find vtsls client', vim.log.levels.ERROR)
                return
            end

            local vtsls_client = vtsls_clients[1]
            local param = unpack(result)
            local id, command, payload = unpack(param)

            vtsls_client:exec_cmd({
                title = 'vue_request_forward',
                command = 'typescript.tsserverRequest',
                arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
                local response = r and r.body
                local response_data = { { id, response } }
                client:notify('tsserver/response', response_data)
            end)
        end
    end,
}
