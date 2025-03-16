-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd('Scratch', function(opts)
    require 'r.extensions.project.scratchpad'(opts.args)
end, { nargs = '*', desc = 'Open scratchpad for a filetype' })

cmd('Project', function(opts)
    require('r.extensions.project').create(opts.args)
end, { nargs = '*', desc = 'Create a project' })

cmd('WordCount', function()
    require('r.extensions').tex_word_count()
end, { desc = 'Display LaTeX project word count' })

cmd('Word', function()
    require('r.extensions').WordProcessor()
end, { desc = 'Turn on WordProcessor mode' })

cmd('GDEditor', function()
    require('r.extensions').godot_editor()
end, { desc = 'Start Godot Server' })

cmd('Su', 'w !sudo tee %', {})

-- ******************* Extensions mappings --------------------------------------------
local map = vim.keymap.set

require('r.utils').lazy_on_key('n', '<leader>r', 'Yazi file picker', function()
    require('r.extensions.mappings').yazi()
end)

require('r.utils').lazy_on_key('n', '<leader>t', 'Open Terminal', function()
    require('r.extensions.mappings').terminal()
end)

-- Misc
map({ 'n', 't' }, '<F9>', function()
    vim.cmd.stopinsert()
    require('r.extensions').toggleTerm('zsh', 'shell', 1)
end, {
    desc = 'Toggle current/default terminal',
})

vim.cmd.GDEditor()
