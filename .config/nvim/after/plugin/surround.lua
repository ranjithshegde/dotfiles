local utils = require 'r.utils'

local function config()
    vim.keymap.set('n', 'gs', '<Plug>(nvim-surround-normal)', {
        desc = 'Add a surrounding pair around a motion (normal mode)',
    })
    vim.keymap.set('n', 'gss', '<Plug>(nvim-surround-normal-cur)', {
        desc = 'Add a surrounding pair around the current line (normal mode)',
    })
    vim.keymap.set('n', 'gS', '<Plug>(nvim-surround-normal-line)', {
        desc = 'Add a surrounding pair around a motion, on new lines (normal mode)',
    })
    vim.keymap.set('n', 'gSS', '<Plug>(nvim-surround-normal-cur-line)', {
        desc = 'Add a surrounding pair around the current line, on new lines (normal mode)',
    })
    vim.keymap.set('x', 'gs', '<Plug>(nvim-surround-visual)', {
        desc = 'Add a surrounding pair around a visual selection',
    })
    vim.keymap.set('x', 'gss', '<Plug>(nvim-surround-visual-line)', {
        desc = 'Add a surrounding pair around a visual selection, on new lines',
    })
end

local surround_keys = {
    { mode = 'n', key = 'cs', desc = 'Change surround' },
    { mode = 'n', key = 'ds', desc = 'Delete surround' },
    { mode = { 'n', 'v' }, key = 'gs', desc = 'Add surround (normal/visual)' },
    { mode = 'v', key = 'gS', desc = 'Add surround (visual linewise)' },
}

local function init()
    local id = { TexRules = vim.api.nvim_create_augroup('TexRules', { clear = true }) }
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

vim.pack.add({ 'https://github.com/kylechui/nvim-surround' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-surround', plug.spec.name, function()
            config()
        end)

        for _, item in ipairs(surround_keys) do
            utils.lazy_on_key(item.mode, item.key, item.desc, function()
                require 'nvim-surround'
            end)
        end
    end,
    confirm = false,
})

init()
