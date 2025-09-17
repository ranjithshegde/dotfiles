return {
    {
        'olimorris/codecompanion.nvim',
        cmd = 'CodeCompanionChat',
        opts = {
            strategies = {
                chat = { adapter = 'copilot' },
                inline = { adapter = 'copilot' },
                cmd = { adapter = 'copilot' },
            },
            extensions = {
                vectorcode = {
                    opts = {
                        tool_group = {
                            enabled = true,
                            extras = { 'file_search' },
                            collapse = true,
                        },
                        tool_opts = {
                            ['*'] = {},
                            query = {
                                max_num = { chunk = -1, document = -1 },
                                default_num = { chunk = 50, document = 20 },
                                include_stderr = false,
                                use_lsp = true,
                                no_duplicate = true,
                                chunk_mode = false,
                                summarise = {
                                    enabled = true,
                                    adapter = 'copilot',
                                    query_augmented = true,
                                },
                            },
                        },
                    },
                },
            },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        'Davidyz/VectorCode',
        version = '*',
        build = 'uv tool upgrade vectorcode',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'VectorCode',
    },
}
