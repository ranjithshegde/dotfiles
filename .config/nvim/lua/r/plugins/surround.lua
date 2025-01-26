local surround = {
    'kylechui/nvim-surround',
    keys = {
        'cs',
        'ds',
        { 'gs', mode = { 'n', 'v' } },
        { 'gS', mode = 'v' },
    },
    opts = {
        keymaps = { normal = 'gs', normal_cur = 'gss', visual = 'gs', visual_line = 'gS' },
    },
}

function surround.init()
    local id = {}
    id.TexRules = vim.api.nvim_create_augroup('TexRules', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        group = id.TexRules,
        callback = function()
            local cfg = require 'nvim-surround.config'
            local function tex_find_environment()
                if vim.g.loaded_nvim_treesitter then
                    local selection = cfg.get_selection {
                        node = 'generic_environment',
                        -- query = {
                        --   capture = "@block.outer",
                        --   type = "textobjects",
                        -- }
                        -- NOTE: ^query doesn't seem to work very reliably with LaTeX environments
                    }
                    if selection then
                        return selection
                    end
                end
                return cfg.get_selection [[\begin%b{}.-\end%b{}]]
                -- NOTE: ^this does not correctly handle \begin{}-\end{} pairs in all cases
                --        (hence we use treesitter if available)
            end
            require('nvim-surround').buffer_setup {
                surrounds = {
                    ['c'] = {
                        add = function()
                            local cmd = cfg.get_input 'Command: '
                            return { { '\\' .. cmd .. '{' }, { '}' } }
                        end,
                        find = [=[\[^\{}%[%]]-%b{}]=],
                        delete = [[^(\[^\{}]-{)().-(})()$]],
                        change = {
                            target = [[^\([^\{}]-)()%b{}()()$]],
                            replacement = function()
                                local cmd = cfg.get_input 'Command: '
                                return { { cmd }, { '' } }
                            end,
                        },
                    },
                    ['C'] = {
                        add = function()
                            local cmd, opts = cfg.get_input 'Command: ', cfg.get_input 'Options: '
                            return { { '\\' .. cmd .. '[' .. opts .. ']{' }, { '}' } }
                        end,
                        find = [[\[^\{}]-%b[]%b{}]],
                        delete = [[^(\[^\{}]-%b[]{)().-(})()$]],
                        change = {
                            target = [[^\([^\{}]-)()%[(.*)()%]%b{}$]],
                            replacement = function()
                                local cmd, opts = cfg.get_input 'Command: ', cfg.get_input 'Options: '
                                return { { cmd }, { opts } }
                            end,
                        },
                    },
                    ['e'] = {
                        add = function()
                            local env = cfg.get_input 'Environment: '
                            return { { '\\begin{' .. env .. '}' }, { '\\end{' .. env .. '}' } }
                        end,
                        find = tex_find_environment,
                        delete = [[^(\begin%b{})().*(\end%b{})()$]],
                        change = {
                            target = [[^\begin{(.-)()%}.*\end{(.-)()}$]],
                            replacement = function()
                                local env = require('nvim-surround.config').get_input 'Environment: '
                                return { { env }, { env } }
                            end,
                        },
                    },
                    ['E'] = {
                        add = function()
                            local env, opts = cfg.get_input 'Environment: ', cfg.get_input 'Options: '
                            return { { '\\begin{' .. env .. '}[' .. opts .. ']' }, { '\\end{' .. env .. '}' } }
                        end,
                        find = tex_find_environment,
                        delete = [[^(\begin%b{}%b[])().*(\end%b{})()$]],
                        change = {
                            target = [[^\begin%b{}%[(.-)()()()%].*\end%b{}$]],
                            replacement = function()
                                local env = cfg.get_input 'Environment options: '
                                return { { env }, { '' } }
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
