return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            workspace_folders = {
                '~/Workspaces/cpp/Projects/MayaFlux/',
            },
        },
        dependencies = 'fang2hou/blink-copilot',
    },
    {
        'fang2hou/blink-copilot',
        dependencies = {
            {
                'saghen/blink.cmp',
                opts = {
                    sources = {
                        default = { 'copilot' },
                        providers = {
                            copilot = {
                                name = 'copilot',
                                module = 'blink-copilot',
                                score_offset = 100,
                                async = true,
                            },
                        },
                    },
                },
                opts_extend = { 'sources.default' },
            },
        },
    },
    {
        'yetone/avante.nvim',
        build = 'make',
        version = false,
        opts = { provider = 'copilot' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'zbirenbaum/copilot.lua',
        },
        cmd = 'AvanteChat',
    },
}
