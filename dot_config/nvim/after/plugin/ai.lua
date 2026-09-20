local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/coder/claudecode.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('claudecode', plug.spec.name, function()
            require('claudecode').setup {
                terminal_cmd = 'claude_local',
            }
        end)

        utils.lazy_command('ClaudeCode', 'claudecode')
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/nwiizo/codex.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('codex', plug.spec.name, true)
        utils.lazy_command('Codex', 'codex')
        utils.lazy_command('CodexResume', 'codex')
    end,
    confirm = false,
})
