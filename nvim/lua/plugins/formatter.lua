return {
    'mhartington/formatter.nvim',
    dependencies = {
            {'WhoIsSethDaniel/mason-tool-installer.nvim',
                opts = function(_, opts)
                    opts.ensure_installed = opts.ensure_installed or {}
                    vim.list_extend(opts.ensure_installed, {
                        {'clang-format', version = '18.1.6'},
                        'stylua',
                    })
                end,
            }
    },
    config = function()
        require 'formatter'.setup {
            logging = true,
            log_level = vim.log.levels.DEBUG,
            filetype = {
                cpp = { require('formatter.filetypes.cpp').clangformat },
                lua = { require('formatter.filetypes.lua').stylua }
            }
        }
    end

}
