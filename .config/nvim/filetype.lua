vim.filetype.add {
    extension = {
        vs = 'glsl',
        vert = 'glsl',
        fs = 'glsl',
        frag = 'glsl',
        gs = 'glsl',
        geom = 'glsl',
        pd_lua = 'lua',
        pd_luax = 'lua',
        cl = 'opencl',
        make = 'make',
    },
    filename = {
        ['mkinitcpio.conf'] = 'confini',
        ['/etc/environment'] = 'confini',
        ['.clang-tidy'] = 'yaml',
        ['mimeapps.list'] = 'confini',
        ['doxyconf'] = 'conf',
    },
    pattern = {
        [vim.env.XDG_CONFIG_HOME .. '/udev/rules.d/.*%.rules'] = 'udevrules',
    },
}
