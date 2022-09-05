vim.b.make = 'dart'

vim.keymap.set('n', '<F5>', function()
    vim.ui.select({ 'aar', 'apk', 'appbundle', 'bundle', 'web' }, { prompt = 'Compile flutter for: ' }, function(choice)
        require('overseer').run_template { name = 'Flutter build', params = { env = choice } }
    end)
end, { desc = 'Build Flutter', buffer = true })

vim.keymap.set('n', '<F6>', function()
    require('overseer').run_template { name = 'Flutter run' }
end, { desc = 'Run Flutter', buffer = true })

vim.keymap.set('n', '<F4>', function()
    require('overseer').run_template { name = 'Run Single' }
end, { desc = 'Run single file', buffer = true })
