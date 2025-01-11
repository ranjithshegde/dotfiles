local gitsigns = {
    'lewis6991/gitsigns.nvim',
}

function gitsigns.config()
    require('gitsigns').setup {
        on_attach = function(bufnr)
            require('r.plugins.git.mappings').signs(bufnr, package.loaded.gitsigns)
        end,
        preview_config = { focusable = false },
    }
    require('r.plugins.git.mappings').fugitive()
end

function gitsigns.init()
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

return gitsigns
