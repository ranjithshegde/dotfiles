local extensions = {}
local exec = vim.api.nvim_command

--- Move selected line by count, similar to unimparied move
---@param cmd string Direction to move in
---@param count integer Number of positions to move, vim.v.count1
function extensions.move_lines(cmd, count)
    local old_fold = vim.wo.foldmethod
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = 'manual'
    end
    vim.cmd.normal { args = { 'm`' }, bang = true }
    vim.cmd.move { args = { cmd, tostring(count) } }
    vim.cmd.normal { args = { '``' }, bang = true }
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = old_fold
    end
end

------------------------------------------------------------------------
--                          Word Processor                            --
------------------------------------------------------------------------

function extensions.WordProcessor()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.bo.expandtab = true
    vim.opt_local.spell = true
    vim.opt_local.complete:append 'k'
    vim.opt_local.spelllang = { 'en_us', 'en_gb' }
    vim.o.thesaurus = vim.fn.stdpath 'config' .. '/thesaurus/mthesaur.txt'

    require('r.extensions.mappings').writer(vim.api.nvim_get_current_buf())
end

---Return word count for the tex project
function extensions.tex_word_count()
    local fs = vim.bo.filetype
    if fs == 'tex' or fs == 'bib' then
        local cmd = { 'texcount', '-inc', '-sum', '-1', vim.fn.expand '%' }

        local on_exit = function(obj)
            vim.notify(obj.stdout)
            vim.notify(obj.stderr)
        end

        vim.system(cmd, { text = true }, on_exit)
    else
        vim.notify(
            string.format(
                'texcount binary only supports latex subtypes. Filetype %s is unsupported, use `wordcount()` instead',
                fs
            )
        )
    end
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- Toggleable terminal
---@param cmd string launch the shell with
---@param name string name/ID for the terminal window
---@param spl number 0 = horizontal split, 1 = vertical split
function extensions.toggleTerm(cmd, name, spl)
    local win = vim.fn.bufwinnr(name)
    local buf = vim.fn.bufexists(name)
    local split = spl and 'belowright vnew' or 'belowright new'
    if win > 0 then
        exec(win .. ' wincmd c')
    elseif buf > 0 then
        exec(split)
        vim.cmd.buffer(name)
        vim.cmd.startinsert()
    else
        exec(split)
        vim.fn.jobstart(cmd, { term = true })
        vim.cmd.startinsert()
        vim.cmd.f(name)
    end
end

---Use Yazi as file picker
---@param path string Patht open yazi from
---@param edit_cmd string Yazi window position - e: open over current buffer - vs: Vertical split - tab drop: in new or existing tab window
---@param float boolean Whether to open Yazi in a floating window
---@param opts table Floating window options
function extensions.yazi(path, edit_cmd, float, opts)
    local cpath = '/tmp/chosenfile'
    local currentPath = vim.fn.expand(path)
    local job_id = nil

    local rc = { name = 'Yazi', edit_cmd = edit_cmd, term = true }
    function rc.on_exit(_, code, _)
        if not code then
            vim.api.nvim_buf_delete(0, { force = true })
        end
        local file = io.open(cpath, 'r')
        if file then
            for f in file:lines() do
                vim.fn.execute(edit_cmd .. f)
            end
            file:close()
            os.remove(cpath)
        end
    end

    if float then
        vim.api.nvim_open_win(
            0,
            true,
            opts or { relative = 'editor', row = 0, col = 30, width = 150, height = 150, border = 'double' }
        )
    end

    vim.cmd.enew()
    if vim.fn.isdirectory(currentPath) then
        job_id = vim.fn.jobstart(string.format('yazi --chooser-file=%s "%s"', cpath, currentPath), rc)
    else
        local dir = vim.fs.dirname(currentPath)
        job_id = vim.fn.jobstart(string.format('yazi --chooser-file=%s "%s"', cpath, dir), rc)
    end
    vim.b.yazi_id = job_id
    vim.cmd.startinsert()
end

function extensions.godot_editor()
    local pipepath = vim.fn.stdpath 'cache' .. '/gdeditor.pipe'

    if not vim.uv.fs_stat(pipepath) and vim.uv.fs_stat 'project.godot' then
        vim.fn.serverstart(pipepath)
    end
end

return extensions
