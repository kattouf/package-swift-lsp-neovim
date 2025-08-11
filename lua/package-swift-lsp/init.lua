---@diagnostic disable-next-line: undefined-global
local vim = vim

-- package-swift-lsp.lua
-- Neovim LSP client configuration for package-swift-lsp
-- Provides smart completions for Swift Package Manager's Package.swift manifest files
-- Designed to work alongside sourcekit-lsp (not replace it)

local M = {}

-- Check if file is a valid Package.swift file
local function is_package_swift_file(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(filename, ':t')

    -- Match exactly "Package.swift" or version-specific manifests like "Package@swift-5.8.swift"
    return basename == 'Package.swift' or basename:match('^Package@swift%-.*%.swift$')
end

-- Setup function for the LSP client
function M.setup(opts)
    opts = opts or {}

    local cmd = opts.cmd or { 'package-swift-lsp' }

    -- Check if binary exists
    if vim.fn.executable(cmd[1]) ~= 1 then
        vim.notify(
            string.format(
                "package-swift-lsp: Binary '%s' not found.\n" ..
                "Install from: https://github.com/kattouf/package-swift-lsp/releases",
                cmd[1]
            ),
            vim.log.levels.WARN
        )
        return
    end

    -- Setup filetype detection for versioned Package.swift files
    vim.filetype.add({
        filename = {
            ['Package.swift'] = 'swift',
        },
        pattern = {
            ['Package@swift%-.*%.swift'] = 'swift',
        }
    })

    -- Register with lspconfig
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')

    -- Define the package-swift-lsp server configuration
    if not configs.package_swift_lsp then
        configs.package_swift_lsp = {
            default_config = {
                cmd = cmd,
                filetypes = { 'swift' },
                root_dir = function(fname)
                    local util = require('lspconfig.util')
                    return util.root_pattern('Package.swift')(fname)
                end,
                single_file_support = false,
                settings = {},
            }
        }
    end

    -- Setup the LSP client
    lspconfig.package_swift_lsp.setup({
        on_attach = function(client, bufnr)
            -- Only attach to Package.swift files
            if not is_package_swift_file(bufnr) then
                vim.schedule(function()
                    vim.lsp.buf_detach_client(bufnr, client.id)
                end)
                return
            end

            -- Call user's on_attach if provided
            if opts.on_attach then
                opts.on_attach(client, bufnr)
            end
        end,
        capabilities = opts.capabilities,
        settings = opts.settings or {},
    })

    vim.notify('package-swift-lsp: Configured for Package.swift completions', vim.log.levels.INFO)
end

return M
