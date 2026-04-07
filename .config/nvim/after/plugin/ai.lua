local utils = require 'r.utils'

local opts = {
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
                        chunk_mode = true,
                        summarise = {
                            enabled = true,
                            adapter = nil,
                            query_augmented = true,
                        },
                    },
                },
            },
        },
    },
}

vim.pack.add({ 'https://github.com/olimorris/codecompanion.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('codecompanion', plug.spec.name, function()
            require('codecompanion').setup(opts)
        end)

        utils.lazy_command('CodeCompanionChat', 'codecompanion')
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/Davidyz/VectorCode' }, {
    load = function(plug)
        utils.lazy_plugin('vectorcode', plug.spec.name)

        utils.lazy_command('VectorCode', 'vectorcode')
    end,
    confirm = false,
})

local id = { PackUpdateHook = vim.api.nvim_create_augroup('BuildVectorCode', { clear = true }) }

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'VectorCode' and (kind == 'install' or kind == 'update') then
        vim.system({ 'uv', 'tool', 'upgrade', 'vectorcode' }, { cwd = ev.data.path })
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks, group = id.PackUpdateHook })

utils.register_au_id(id)
