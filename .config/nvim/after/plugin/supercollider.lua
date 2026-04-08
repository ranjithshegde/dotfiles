local utils = require 'r.utils'

local function config()
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
            ['sk'] = map('signature.show', 'n'),
            ['<leader>s'] = map(function()
                vim.cmd.drop { args = { '~/.config/SuperCollider/startup.scd' }, mods = { tab = 1 } }
            end),
        },
        completion = { signature = { config = { border = 'rounded' } } },
        postwin = { float = { enabled = true } },
    }

    vim.api.nvim_create_autocmd('InsertEnter', {
        group = vim.g.au_id.PluginLoad,
        pattern = { '*.scd', '*.sc', '*.quark' },
        callback = function()
            require('luasnip').add_snippets('supercollider', require('scnvim/utils').get_snippets())
        end,
        once = true,
    })
end

local function init()
    local id = { scnvim = vim.api.nvim_create_augroup('scnvim', { clear = true }) }
    vim.api.nvim_create_autocmd('FileType', {
        group = id.scnvim,
        pattern = 'supercollider',
        callback = function()
            vim.wo.wrap = true
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            if not package.loaded['scnvim'] then
                config()
            end
            if not require('scnvim').is_running() then
                require('scnvim').start()
            end
        end,
        desc = 'Load SCNvim settings and launch interpreter on filetype',
    })

    require('r.utils').register_au_id(id)
end

vim.pack.add({ 'https://github.com/davidgranstrom/scnvim' }, {
    load = function(plug)
        utils.lazy_plugin('scnvim', plug.spec.name, function()
            config()
        end)
        vim.cmd.packadd { args = { plug.spec.name }, bang = true }

        utils.lazy_event('FileType', 'scnvim', 'supercollider')
    end,
    confirm = false,
})

init()
