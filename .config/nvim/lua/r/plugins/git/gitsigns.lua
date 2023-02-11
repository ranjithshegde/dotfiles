local gitsigns = {
    'lewis6991/gitsigns.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
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

function gitsigns.init() end

return gitsigns
