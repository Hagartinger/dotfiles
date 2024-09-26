return {
    'mhartington/formatter.nvim',
    config = function()
        require 'formatter'.setup {
            logging = true,
            log_level = vim.log.levels.DEBUG,
            filetype = {
                cpp = { require('formatter.filetypes.cpp').clangformat }
            }
        }
    end

}
