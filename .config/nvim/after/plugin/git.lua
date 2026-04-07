local utils = require 'r.utils'

local function sign_config()
    require('gitsigns').setup {
        on_attach = function(bufnr)
            require('r.plugins.git').signs(bufnr, package.loaded.gitsigns)
        end,
        preview_config = { focusable = false },
    }
    require('r.plugins.git').git()
end

local function signs_init()
    local id = { GitSigns = vim.api.nvim_create_augroup('GitSigns', { clear = true }) }
    vim.api.nvim_create_autocmd({ 'BufReadpost', 'VimEnter', 'DirChanged' }, {
        group = id.GitSigns,
        callback = function(args)
            local git_dir = vim.uv.fs_stat(vim.uv.cwd() .. '/.git')
            if (git_dir and git_dir.type == 'directory') or vim.env.GIT_DIR then
                vim.cmd.packadd 'gitsigns.nvim'
                vim.api.nvim_del_autocmd(args.id)
            end
        end,
    })
    require('r.utils').register_au_id(id)
end

vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('gitsigns', plug.spec.name, function()
            sign_config()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/NeogitOrg/neogit' }, {
    load = function(plug)
        utils.lazy_plugin('neogit', plug.spec.name, function()
            require 'plenary'
            require('neogit').setup {
                kind = 'split',
                disable_insert_on_commit = true,
                graph_style = 'kitty',
                process_spinner = true,
                integrations = {
                    diffview = true,
                    fzf_lua = true,
                },
            }
        end)

        utils.lazy_command('Neogit', 'neogit')
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/sindrets/diffview.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('diffview', plug.spec.name)
        utils.lazy_command({ 'DiffViewOpen', 'DiffViewFileHistory' }, 'diffview')
    end,
    confirm = false,
})

signs_init()
