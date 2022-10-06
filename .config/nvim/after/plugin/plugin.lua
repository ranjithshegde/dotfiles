-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd('Scratch', function(opts)
    require 'r.utils.project.scratchpad'(opts.args)
end, { nargs = '*', desc = 'Open scratchpad for a filetype' })

cmd('Project', function(opts)
    require('r.utils.project').create(opts.args)
end, { nargs = '*', desc = 'Create a project' })

cmd('WordCount', function()
    require('r.utils.ls').tex_word_count()
end, { desc = 'Display text word count in the buffer' })

cmd('Agenda', function()
    require('packer').loader 'orgmode'
    require('orgmode').action 'agenda.prompt'
end, { desc = 'Open Orgmode agenda' })

cmd('Word', function()
    require('r.utils.extensions').WordProcessor()
end, { desc = 'Turn on WordProcessor mode' })

cmd('Camel', function()
    require('r.utils.extensions').CamelCase()
end, { desc = 'Turn word and motion operators into camelcase' })

cmd('ToggleTransparency', function()
    require('r.utils.extensions').trans_background()
end, { desc = 'Toggle background transpparency for dark scheme' })

cmd('Su', 'w !sudo tee %', {})

-- ******************* Plugin mappings --------------------------------------------

local function load_plugin_on_key(mode, key, desc, callback, args)
    vim.keymap.set(mode, key, function()
        vim.keymap.del(mode, key)
        callback(args)
        key = string.gsub(key, '<leader>', '\\')
        vim.api.nvim_input(key)
    end, { desc = desc })
end

load_plugin_on_key('n', '<Space>', 'Telescope', require, 'r.mappings.telescope')

load_plugin_on_key('n', 'cr', 'Coerce', require('packer').loader, 'vim-abolish')

load_plugin_on_key('n', '<leader>r', 'Ranger file picker', function()
    require('r.mappings.util').ranger()
end)

load_plugin_on_key('n', '<leader>w', 'OrgWiki', function()
    require('r.mappings.util').orgWiki()
end)
