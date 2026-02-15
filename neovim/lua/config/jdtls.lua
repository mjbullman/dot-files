-- ===============================
-- nvim-jdtls Configuration
-- Author: Martin Bullman
-- ===============================

local jdtls = require('jdtls')

-- =============================
-- Paths
-- =============================
local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local jdtls_path = mason_path .. '/jdtls'
local java_debug_path = mason_path .. '/java-debug-adapter'
local java_test_path = mason_path .. '/java-test'

-- find the launcher JAR
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

-- platform-specific config dir
local os_config = jdtls_path .. '/config_mac'
if vim.fn.has('linux') == 1 then
    os_config = jdtls_path .. '/config_linux'
end

-- workspace directory (per-project)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name

-- =============================
-- Debug / test bundles
-- =============================
local bundles = {}

-- java-debug-adapter
local debug_jar = vim.fn.glob(
    java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar',
    true
)
if debug_jar ~= '' then
    table.insert(bundles, debug_jar)
end

-- java-test
local test_jars = vim.split(
    vim.fn.glob(java_test_path .. '/extension/server/*.jar', true),
    '\n'
)
for _, jar in ipairs(test_jars) do
    if jar ~= '' and not vim.endswith(jar, 'com.microsoft.java.test.runner-jar-with-dependencies.jar') then
        table.insert(bundles, jar)
    end
end

-- =============================
-- jdtls configuration
-- =============================
local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_jar,
        '-configuration', os_config,
        '-data', workspace_dir,
    },

    root_dir = jdtls.setup.find_root({
        '.git',
        'mvnw',
        'gradlew',
        'pom.xml',
        'build.xml',
        'build.gradle',
        'settings.gradle',
        'build.gradle.kts',
        'settings.gradle.kts',
    }),

    capabilities = require('blink.cmp').get_lsp_capabilities(),

    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    'org.hamcrest.MatcherAssert.assertThat',
                    'org.hamcrest.Matchers.*',
                    'org.hamcrest.CoreMatchers.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'java.util.Objects.requireNonNull',
                    'java.util.Objects.requireNonNullElse',
                    'org.mockito.Mockito.*',
                },
                filteredTypes = {
                    'com.sun.*',
                    'io.micrometer.shaded.*',
                    'java.awt.*',
                    'jdk.*',
                    'sun.*',
                },
                importOrder = {
                    'java',
                    'javax',
                    'com',
                    'org',
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            configuration = {
                updateBuildConfiguration = 'interactive',
            },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            inlayHints = {
                parameterNames = { enabled = 'all' },
            },
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
        },
    },

    init_options = {
        bundles = bundles,
    },

    on_attach = function(_, bufnr)
        -- setup DAP integration
        jdtls.setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()

        -- enable codelens (shows "▶ Run | Debug" above main/test methods)
        vim.defer_fn(function()
            vim.lsp.codelens.refresh()
        end, 3000)
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })

        -- buffer-local Java keymaps
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', '<leader>jo', jdtls.organize_imports, 'Organize imports')
        map('n', '<leader>jv', jdtls.extract_variable, 'Extract variable')
        map('n', '<leader>jc', jdtls.extract_constant, 'Extract constant')
        map('v', '<leader>jm', function() jdtls.extract_method(true) end, 'Extract method')
        map('n', '<leader>jt', function() jdtls.test_nearest_method() end, 'Test nearest method')
        map('n', '<leader>jT', function() jdtls.test_class() end, 'Test class')
        map('n', '<leader>jp', function() jdtls.pick_test() end, 'Pick test')
        map('n', '<leader>ju', '<cmd>JdtUpdateConfig<cr>', 'Update project config')
        map('n', '<leader>jr', function()
            vim.cmd('term java ' .. vim.fn.expand('%'))
        end, 'Run main class')
        map('n', '<leader>jd', function()
            require('jdtls.dap').setup_dap_main_class_configs()
            vim.defer_fn(function() require('dap').continue() end, 1000)
        end, 'Debug main class')
    end,
}

-- =============================
-- Start jdtls on Java files
-- =============================
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
        jdtls.start_or_attach(config)
    end,
})

-- also start immediately if current buffer is Java
if vim.bo.filetype == 'java' then
    jdtls.start_or_attach(config)
end
