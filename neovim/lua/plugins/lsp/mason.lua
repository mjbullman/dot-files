return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Get capabilities from blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      -- Setup mason-lspconfig with handlers (proper way to configure servers)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "vue_ls",          -- Vue 3 LSP with built-in TypeScript support
          "html",            -- HTML support
          "cssls",           -- CSS/SCSS/Less support
          "eslint",          -- ESLint integration
          "jsonls",          -- JSON support
          "yamlls",          -- YAML support
        },
        handlers = {
          -- Default handler for servers without custom config
          function(server_name)
            lspconfig[server_name].setup({ capabilities = capabilities })
          end,

          -- TypeScript/JavaScript LSP (vtsls) with Vue support via @vue/typescript-plugin
          ["vtsls"] = function()
            -- Path to vue-language-server installed by Mason
            local vue_language_server_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

            lspconfig.vtsls.setup({
              capabilities = capabilities,
              filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
              settings = {
                vtsls = {
                  tsserver = {
                    globalPlugins = {
                      {
                        name = "@vue/typescript-plugin",
                        location = vue_language_server_path,
                        languages = { "vue" },
                      },
                    },
                  },
                  typescript = {
                    inlayHints = {
                      enumMemberValues = { enabled = true },
                      functionLikeReturnTypes = { enabled = true },
                      parameterNames = { enabled = "literals" },
                      parameterTypes = { enabled = true },
                      propertyDeclarationTypes = { enabled = true },
                      variableTypes = { enabled = true },
                    },
                    preferences = {
                      disableSuggestions = false,
                      quotePreference = "single",
                      importModuleSpecifierPreference = "relative",
                      importModuleSpecifierEnding = "js",
                    },
                    suggest = {
                      completeFunctionCalls = true,
                    },
                  },
                  javascript = {
                    inlayHints = {
                      enumMemberValues = { enabled = true },
                      functionLikeReturnTypes = { enabled = true },
                      parameterNames = { enabled = "literals" },
                      parameterTypes = { enabled = true },
                      propertyDeclarationTypes = { enabled = true },
                      variableTypes = { enabled = true },
                    },
                    preferences = {
                      disableSuggestions = false,
                      quotePreference = "single",
                      importModuleSpecifierPreference = "relative",
                      importModuleSpecifierEnding = "js",
                    },
                    suggest = {
                      completeFunctionCalls = true,
                    },
                  },
                },
              },
            })
          end,

          -- Vue 3 LSP (vue_ls) - renamed from volar
          ["vue_ls"] = function()
            lspconfig.vue_ls.setup({
              capabilities = capabilities,
              filetypes = { "vue" },
            })
          end,

          -- HTML
          ["html"] = function()
            lspconfig.html.setup({
              capabilities = capabilities,
              settings = {
                html = {
                  format = {
                    templating = true,
                    wrapLineLength = 120,
                  },
                },
              },
            })
          end,

          -- CSS/SCSS/Less
          ["cssls"] = function()
            lspconfig.cssls.setup({
              capabilities = capabilities,
              settings = {
                css = {
                  validate = true,
                  lint = {
                    compatibleVendorPrefixes = "warning",
                    vendorPrefix = "warning",
                    duplicateProperties = "warning",
                  },
                },
                scss = {
                  validate = true,
                  lint = {
                    compatibleVendorPrefixes = "warning",
                    vendorPrefix = "warning",
                    duplicateProperties = "warning",
                  },
                },
                less = {
                  validate = true,
                },
              },
            })
          end,

          -- ESLint (as linter only - format manually with <leader>lf)
          ["eslint"] = function()
            lspconfig.eslint.setup({ capabilities = capabilities })
          end,

          -- JSON
          ["jsonls"] = function()
            lspconfig.jsonls.setup({
              capabilities = capabilities,
              settings = {
                json = {
                  validate = { enable = true },
                  schemas = {
                    {
                      fileMatch = { "package.json" },
                      url = "https://json.schemastore.org/package.json",
                    },
                    {
                      fileMatch = { "tsconfig.json" },
                      url = "https://json.schemastore.org/tsconfig.json",
                    },
                    {
                      fileMatch = { ".eslintrc.json" },
                      url = "https://json.schemastore.org/eslintrc.json",
                    },
                  },
                },
              },
            })
          end,

          -- YAML
          ["yamlls"] = function()
            lspconfig.yamlls.setup({
              capabilities = capabilities,
              settings = {
                yaml = {
                  schemas = {
                    kubernetes = "k8s/**/*.yaml",
                    ["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
                    ["http://json.schemastore.org/kube-score.json"] = "*.yaml",
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
}

