local function sign_config()
    require('gitsigns').setup {
        on_attach = function(bufnr)
            require('r.plugins.git.mappings').signs(bufnr, package.loaded.gitsigns)
        end,
        preview_config = { focusable = false },
    }
    require('r.plugins.git.mappings').fugitive()
end

local function signs_init()
    local id = {}
    id.GitSigns = vim.api.nvim_create_augroup('GitSigns', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufReadpost', 'VimEnter', 'DirChanged' }, {
        group = id.GitSigns,
        callback = function(args)
            local git_dir = vim.uv.fs_stat(vim.uv.cwd() .. '/.git')
            if (git_dir and git_dir.type == 'directory') or vim.env.GIT_DIR then
                require('lazy').load { plugins = { 'gitsigns.nvim' } }
                vim.api.nvim_del_autocmd(args.id)
            end
        end,
    })
    require('r.utils').register_au_id(id)
end

return {
    {
        'lewis6991/gitsigns.nvim',
        init = signs_init,
        config = sign_config,
    },
    {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim',
        },
        opts = {
            kind = 'split',
            disable_insert_on_commit = true,
            graph_style = 'kitty',
            process_spinner = true,
            integrations = {
                diffview = true,
            },
        },
        cmd = 'Neogit',
    },
    { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gclog' } },
}
