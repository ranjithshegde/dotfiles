local function navigate(prompt_bufnr, maps, cwd, files)
    local change_dir = function(window)
        local wd = require('telescope.actions.state').get_selected_entry().value
        require('telescope.actions.set').select(prompt_bufnr, window)
        if files then
            vim.cmd.tcd(cwd)
        end
        if not require('plenary.path'):new(wd):is_dir() then
            local dir = vim.fn.fnamemodify(wd, ':p:h')
            vim.cmd.tcd(dir)
        end
    end
    maps('n', '<CR>', function()
        change_dir 'default'
    end)
    maps('i', '<CR>', function()
        change_dir 'default'
    end)
    maps('n', '<C-v>', function()
        change_dir 'vertical'
    end)
    maps('i', '<C-v>', function()
        change_dir 'vertical'
    end)
    maps('n', '<C-t>', function()
        change_dir 'tab'
    end)
    maps('i', '<C-t>', function()
        change_dir 'tab'
    end)
    return true
end

local cursor_layout = { width = 0.8, height = 0.6 }

------------------------------------------------------------------------
--                       Telescope 									  --
------------------------------------------------------------------------

local telescope = {}

function telescope.cdBrowser(prompt, cwd)
    require('telescope').extensions.file_browser.file_browser {
        prompt_title = prompt,
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, maps)
            return navigate(prompt_bufnr, maps, cwd, false)
        end,
    }
end

function telescope.cdFiles(prompt, cwd)
    require('telescope.builtin').find_files {
        prompt_title = prompt,
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, maps)
            return navigate(prompt_bufnr, maps, cwd, true)
        end,
    }
end

function telescope.telescope()
    require 'r.plugins.telescope.mappings'
    local layout_actions = require 'telescope.actions.layout'
    require('telescope').setup {
        pickers = {
            buffers = {
                show_all_buffers = true,
                sort_lastused = true,
                mappings = {
                    i = {
                        ['<c-x>'] = 'delete_buffer',
                    },
                },
            },
            loclist = { theme = 'ivy' },
            quickfix = { theme = 'ivy' },
            find_files = { follow = true },
            lsp_document_symbols = { theme = 'ivy' },
            current_buffer_fuzzy_find = { theme = 'ivy' },
            lsp_references = { theme = 'cursor', layout_config = cursor_layout },
            lsp_workspace_symbols = { theme = 'cursor', layout_config = cursor_layout },
        },
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '-L',
            },
            layout_strategy = 'flex',
            prompt_prefix = '❯ ',
            selection_caret = '❯ ',
            dynamic_preview_title = true,
            cycle_layout_list = { 'vertical', 'bottom_pane', 'center', 'flex' },
            file_ignore_patterns = require('r.utils.tables').ignore_binaries,
            mappings = {
                i = {
                    ['<C-h>'] = 'which_key',
                    ['<c-e>'] = layout_actions.toggle_preview,
                    ['<c-l>'] = layout_actions.cycle_layout_next,
                },
            },
        },
        extensions = {
            project = {
                base_dirs = {
                    { '~/Documents/LaTeX', max_depth = 3 },
                    { '~/Repositories/libraries/', max_depth = 2 },
                    { '~/Workspaces/lua', max_depth = 4 },
                    { '~/Workspaces/cpp', max_depth = 4 },
                    { '~/Workspaces/Repos', max_depth = 4 },
                    { '~/Workspaces/electronics', max_depth = 4 },
                    { '~/Workspaces/openFrameworks', max_depth = 5 },
                    { '~/Workspaces/websites/', max_depth = 3 },
                },
            },
        },
    }
    require('telescope').load_extension 'fzf'
    if package.loaded.refactoring then
        require('telescope').load_extension 'refactoring'
    end
    if package.loaded.harpoon then
        require('telescope').load_extension 'harpoon'
    end
    if package.loaded.noice then
        require('telescope').load_extension 'noice'
    end
end

return telescope
