-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd('Scratch', function(opts)
    require 'r.extensions.project.scratchpad'(opts.args)
end, { nargs = '*', desc = 'Open scratchpad for a filetype' })

cmd('Project', function(opts)
    require('r.extensions.project').create(opts.args)
end, { nargs = '*', desc = 'Create a project' })

cmd('WordCount', function()
    require('r.lsp.texlab').tex_word_count()
end, { desc = 'Display text word count in the buffer' })

cmd('Agenda', function()
    require('orgmode').action 'agenda.prompt'
end, { desc = 'Open Orgmode agenda' })

cmd('Word', function()
    require('r.extensions').WordProcessor()
end, { desc = 'Turn on WordProcessor mode' })

cmd('Camel', function()
    require('lazy').load { plugins = { 'vim-wordmotion' } }
end, { desc = 'Use CamelCase motions' })

cmd('Su', 'w !sudo tee %', {})

-- ******************* Plugin mappings --------------------------------------------

require('r.utils').lazy_on_key('n', '<leader>r', 'Ranger file picker', function()
    require('r.mappings.util').ranger()
end)
