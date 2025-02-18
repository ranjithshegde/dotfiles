return function(id)
    local function ftcmd(au_id, type, func, desc)
        if not vim.tbl_contains(vim.tbl_keys(id), au_id) then
            id[au_id] = vim.api.nvim_create_augroup(au_id, { clear = true })
        end
        vim.api.nvim_create_autocmd('FileType', {
            group = au_id,
            pattern = type,
            desc = desc,
            callback = function(args)
                if not vim.b[args.buf][args.id] then
                    vim.b[args.buf][args.id] = true
                    func(args)
                end
            end,
        })
    end

    ------------------------------------------------------------------------
    --                              C Type                                --
    ------------------------------------------------------------------------

    ftcmd('CProjectSetup', { 'c', 'cpp' }, function(args)
        require('r.extensions.project.detection').setup(args.buf)

        vim.keymap.set('n', '<leader>M', function()
            vim.cmd.tabnew(vim.b.makeFile)
        end, { desc = 'Open Makefile', buffer = args.buf })

        require('r.extensions.project.docs').mappings(args.buf)
    end, 'Default Cpp ftplugin')

    ftcmd('C_style', { 'c', 'cpp', 'opencl', 'glsl' }, function(args)
        vim.bo[args.buf].commentstring = '//%s'
    end, 'Default commenstring for c style filetype')

    ftcmd('C_style', 'glsl', function(args)
        vim.keymap.set('n', '<leader>s', function()
            if vim.fn.expand '%:e' == 'vert' then
                vim.cmd.edit(vim.fn.expand '%:r' .. '.frag')
            else
                vim.cmd.edit(vim.fn.expand '%:r' .. '.vert')
            end
        end, { buffer = args.buf, silent = true, desc = 'Open alternate shader file' })
    end, 'Switch between glsl types')

    ------------------------------------------------------------------------
    --                              Project Setup                         --
    ------------------------------------------------------------------------

    ftcmd('repl', { 'lua', 'python', 'javascript' }, function(args)
        vim.keymap.set({ 'n', 't' }, '<F10>', function()
            vim.cmd.stopinsert()
            require('r.extensions').toggleTerm(vim.b[args.buf].repl, 'repl')
        end, { desc = 'Toggle REPL', buffer = args.buf })
    end, 'set toggleable REPL for capable filetypes')

    -- ************** Web Development  ---------------------------------------
    ftcmd('WebDev', { 'css', 'html' }, function()
        require('r.utils').switch_alternate()
    end, 'Default ftplugin for css and html')

    ftcmd('WebDev', 'javascript', function()
        vim.b.repl = 'node'
        vim.b.make = 'node'
    end, 'Default ftplugin for javascript')

    -- ************** Lua and Pd ---------------------------------------
    ftcmd('Eval_file', 'lua', function(args)
        local file = vim.fn.expand '%:t:r'
        if vim.uv.fs_stat(file .. '.pd_lua') then
            vim.b[args.buf].isPD = true
        end

        vim.b[args.buf].repl = 'rlwrap luajit'
        vim.b[args.buf].make = 'luajit'

        require('r.utils').write_and_source(args.buf)
    end, 'Lua project setup')

    -- ************** Python ---------------------------------------
    ftcmd('Eval_file', 'python', function(args)
        vim.b[args.buf].repl = 'ipython'
        vim.b[args.buf].make = 'python'
    end, 'Python project setup')

    -- ************** Latex ---------------------------------------
    ftcmd('Eval_file', 'tex', function(args)
        vim.keymap.set('n', '<F3>', vim.cmd.WordCount, { buffer = args.buf, desc = 'Word count' })

        vim.bo[args.buf].makeprg = 'latexmk'
        vim.b[args.buf].gps = 75
        vim.bo[args.buf].textwidth = 148
        require('r.extensions').WordProcessor()
    end, 'Latex project setup')

    ------------------------------------------------------------------------
    --                              Misc                                  --
    ------------------------------------------------------------------------

    ftcmd('FoldMaps', '', function(args)
        if not vim.tbl_contains(require('r.utils.tables').ignoreFiles, args.match) or args.match ~= 'org' then
            vim.keymap.set('n', '<Tab>', 'za', { buffer = args.buf, desc = 'Toggle fold current' })
            vim.keymap.set('n', '<S-Tab>', 'zA', { buffer = args.buf, desc = 'Toggle fold All' })
        end
    end, 'Use Tab to cycle folds')

    ftcmd('QuickFix', 'qf', function(args)
        vim.keymap.set('n', 'L', vim.cmd.cnewer, { buffer = args.buf, desc = 'Jump to Next list' })
        vim.keymap.set('n', 'H', vim.cmd.colder, { buffer = args.buf, desc = 'Jump to previous list' })
        vim.keymap.set(
            'n',
            'dd',
            require('r.extensions.qf').delete,
            { buffer = args.buf, desc = 'Delete quickfix item' }
        )
        vim.keymap.set(
            { 'v' },
            'd',
            require('r.extensions.qf').delete,
            { buffer = args.buf, desc = 'Delete quickfix item' }
        )
    end, 'Use Tab to cycle folds')
end
