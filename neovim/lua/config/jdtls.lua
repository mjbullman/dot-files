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

-- java-test: only the test *plugin* is a jdtls OSGi bundle. The rest of the
-- jars in this dir (jacocoagent, org.jacoco.*, junit-*) are plain runtime
-- libraries with no OSGi metadata, so feeding them to jdtls throws
-- "Failed to get bundleInfo for bundle".
local test_plugin_jar = vim.fn.glob(
    java_test_path .. '/extension/server/com.microsoft.java.test.plugin-*.jar',
    true
)
if test_plugin_jar ~= '' then
    table.insert(bundles, test_plugin_jar)
end

-- =============================
-- jdtls configuration
-- =============================
-- jdtls itself requires Java 21+ to run. Resolve the binary at runtime instead of
-- hardcoding a versioned Homebrew path: the /opt/homebrew/opt/openjdk@<n> aliases are
-- left behind by upgraded formulae, so they can disappear or silently resolve to a
-- different JDK than their name suggests.
local function resolve_java()
    local candidates = {}

    -- jenv's export plugin sets JAVA_HOME to the active version
    if vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= '' then
        table.insert(candidates, vim.env.JAVA_HOME .. '/bin/java')
    end

    table.insert(candidates, '/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home/bin/java')

    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end

    -- last resort: whatever java is on PATH
    local on_path = vim.fn.exepath('java')
    return on_path ~= '' and on_path or 'java'
end

local config = {
    cmd = {
        resolve_java(),
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx2g',
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
            configuration = {
                updateBuildConfiguration = 'interactive',
                -- Only JDK 25 (current LTS) is installed; 17, 21 and 22 were removed.
                -- Do NOT point entries at /opt/homebrew/opt/openjdk@<n> without checking
                -- what they resolve to: those aliases are left behind by upgraded
                -- formulae and can silently resolve to a completely different JDK.
                runtimes = {
                    {
                        name = 'JavaSE-25',
                        path = '/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home',
                        default = true,
                    },
                },
            },
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
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
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
        -- register the java DAP adapter. Main-class config resolution is done
        -- lazily in the <leader>jd mapping below, not here: resolving on every
        -- attach fires java-debug's resolveJavaExecutable on each file open,
        -- which crashes in adapter 0.53.2.
        jdtls.setup_dap({ hotcodereplace = 'auto', config_overrides = {} })

        -- buffer-local Java keymaps
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', '<leader>jo', jdtls.organize_imports, 'Organize imports')
        map('n', '<leader>jv', jdtls.extract_variable, 'Extract variable')
        map('n', '<leader>jc', jdtls.extract_constant, 'Extract constant')
        map('v', '<leader>jm', function() jdtls.extract_method(true) end, 'Extract method')
        map('n', '<leader>jp', function() jdtls.pick_test() end, 'Pick test')
        map('n', '<leader>ju', '<cmd>JdtUpdateConfig<cr>', 'Update project config')
        map('n', '<leader>jr', function()
            vim.cmd('term java ' .. vim.fn.expand('%'))
        end, 'Run main class')

        -- Test and debug keys are language-agnostic and live in plugins/debugging.lua:
        -- <leader>dn (nearest test), <leader>dC (test class), <leader>dc (continue —
        -- registers jdtls main-class configs on first use in a project).
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
