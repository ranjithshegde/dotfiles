local plugins = {}

------------------------------------------------------------------------
--                      Config for various plugins                    --
------------------------------------------------------------------------

---neodev
function plugins.neodev()
    require('neodev').setup {
        library = { plugins = false },
        override = function(_, library)
            library.enabled = true
        end,
    }
end

---Gitsigns
function plugins.gitsigns()
    require('gitsigns').setup {
        on_attach = function(bufnr)
            require('r.mappings.git').signs(bufnr, package.loaded.gitsigns)
        end,
        preview_config = { focusable = false },
    }
    require('r.mappings.git').fugitive()
end

---IndentBlankline
function plugins.indent()
    require('indent_blankline').setup {
        show_current_context = true,
        use_treesitter = true,
    }
    for _, v in pairs(require('r.utils.tables').indentContext) do
        vim.cmd("let g:indent_blankline_context_patterns+=['" .. v .. "']")
    end
end

---Fancy UI
function plugins.ui()
    require('noice').setup {
        -- debug = true,
        cmdline = {
            view = 'cmdline',
            view_search = 'cmdline',
            format = {
                inc_rename = { pattern = '^:%s*IncRename%s+', icon = ' ', ft = 'text' },
            },
        },
    }
end

---nvim-colorizer
function plugins.colorizer()
    require('colorizer').setup {
        filetypes = {
            '*',
            cpp = { AARRGGBB = true },
            yaml = { AARRGGBB = true },
            html = { mode = 'foreground' },
            css = { rgb_fn = true, css_fn = true },
        },
    }
end

---OrgMode
function plugins.org()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup {
        org_agenda_files = {
            '~/Documents/Orgs/*',
            '~/Documents/Orgs/*/*',
            '~/Documents/Orgs/*/*/*',
            '~/Documents/Orgs/*/*/*/*',
        },
        org_highlight_latex_and_related = 'entities',
        emacs_config = { config_path = '$XDG_CONFIG_HOME/emacs/init.el' },
    }
end

---nvim-surround local and global config
function plugins.surround()
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

---SuperCollider
function plugins.scnvim()
    local scnvim = require 'scnvim'
    local map = scnvim.map
    local map_expr = scnvim.map_expr
    scnvim.setup {
        keymaps = {
            ['<F1>'] = map 'sclang.start',
            ['<F2>'] = map 'sclang.poll_server_status',
            ['<F3>'] = map(function()
                require('scnvim.sclang').send 'Server.local.boot'
                vim.defer_fn(function()
                    vim.api.nvim_exec_autocmds('User', { pattern = 'ScStatus' })
                end, 4000)
            end),
            ['<F4>'] = map_expr 'WFS.startup',
            ['<F6>'] = map('editor.send_line', { 'i', 'n' }),
            ['<F5>'] = {
                map('editor.send_block', { 'i', 'n' }),
                map('editor.send_selection', 'x'),
            },
            ['<F12>'] = map('sclang.hard_stop', { 'n', 'x', 'i' }),
            ['<CR>'] = map('postwin.toggle', 'n'),
            ['<C-CR>'] = map('postwin.toggle', 'i'),
            ['<M-L>'] = map('postwin.clear', { 'n', 'i' }),
            [',s'] = map('signature.show', 'n'),
            ['<leader>s'] = map(function()
                vim.cmd.drop { args = { '~/.config/SuperCollider/startup.scd' }, mods = { tab = 1 } }
            end),
            ['K'] = map(function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    require('scnvim.help').open_help_for(vim.fn.expand '<cword>')
                end
            end),
        },
        completion = { signature = { config = { border = 'rounded' } } },
    }
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.g.au_id.LspSettngs,
        pattern = 'supercollider',
        callback = function()
            vim.wo.wrap = true
            if not require('scnvim').is_running() then
                require('scnvim').start()
                vim.api.nvim_input '<CR>'
            end
        end,
        desc = 'Load SCNvim settings and launch interpreter on filetype',
    })
end

return plugins
