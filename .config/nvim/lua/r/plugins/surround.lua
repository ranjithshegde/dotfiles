local surround = {
    'kylechui/nvim-surround',
    keys = { 'ys', 'yss', 'ySS', 'cs', 'ds', { 'S', mode = 'v' } },
}

function surround.config()
    local ft = vim.bo.filetype
    require('nvim-surround').setup {}
    if ft == 'tex' then
        local get_input = require('nvim-surround.config').get_input
        require('nvim-surround').buffer_setup {
            surrounds = {
                ['f'] = {
                    add = function()
                        local result = get_input 'Enter the function name: '
                        if result then
                            return { { '\\' .. result .. '{' }, { '}' } }
                        end
                    end,
                    find = '\\%a+%b{}',
                    delete = '^(\\%a+{)().-(})()$',
                    change = {
                        target = '^\\(%a+)(){.-}()()$',
                        replacement = function()
                            local result = get_input 'Enter the function name: '
                            if result then
                                return { { result }, { '' } }
                            end
                        end,
                    },
                },
            },
        }
    end
end

return surround
