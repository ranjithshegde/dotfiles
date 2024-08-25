local surround = {
    'kylechui/nvim-surround',
    keys = { 'gs', 'cs', 'ds', { 'S', mode = 'v' } },
    opts = { keymaps = { normal = 'gs', normal_cur = 'gss' } },
}

function surround.init()
    local id = {}
    id.TexRules = vim.api.nvim_create_augroup('TexRules', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        group = id.TexRules,
        callback = function()
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
        end,
    })

    require('r.utils').register_au_id(id)
end

return surround
