return function()
    require('neodev').setup {
        library = { plugins = false },
        override = function(_, library)
            library.enabled = true
        end,
        lspconfig = false,
    }
end
