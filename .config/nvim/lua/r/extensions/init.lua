local extensions = {}
local exec = vim.api.nvim_command

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
    vim.o.thesaurus = vim.env.XDG_CONFIG_HOME .. '/nvim/thesaurus/mthesaur.txt'
    require('r.mappings.util').wordProcessor()
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

---Use ranger as file picker
---@param path string Patht open ranger from
---@param edit_cmd string Ranger window position - e: open over current buffer - vs: Vertical split - tab drop: in new or existing tab window
function extensions.ranger(path, edit_cmd)
    local cpath = '/tmp/chosenfile'
    local currentPath = vim.fn.expand(path)
    local rc = { name = 'ranger', edit_cmd = edit_cmd, term = true }
    function rc.on_exit(_, code, _)
        if not code then
            vim.api.nvim_buf_delete(0, { force = true })
        end
        if io.open(cpath, 'r') then
            for f in io.lines(cpath) do
                vim.fn.execute(edit_cmd .. f)
            end
            os.remove(cpath)
        end
    end

    vim.cmd.enew()
    if vim.fn.isdirectory(currentPath) then
        vim.fn.jobstart('ranger --choosefiles=' .. cpath .. ' "' .. currentPath .. '"', rc)
    else
        vim.fn.jobstart('ranger --choosefiles=' .. cpath .. ' --selectfile="' .. currentPath .. '"', rc)
    end
    vim.cmd.startinsert()
end

---Return word count for the tex project
function extensions.tex_word_count()
    local fs = vim.bo.filetype
    if fs == 'tex' or fs == 'bib' then
        local result = ''
        local handle
        local output = vim.uv.new_pipe(false)

        handle = vim.uv.spawn('texcount', {
            args = { '-inc', '-sum', '-1', vim.fn.expand '%' },
            stdio = { nil, output, nil },
        }, function(code)
            if code == 0 then
                output:read_stop()
                output:close()
            else
                vim.notify('texcount failed with exit code ' .. code, vim.log.levels.ERROR)
            end
        end)

        output:read_start(function(err, chunk)
            if err then
                vim.notify('Error reading texcount output: ' .. err, vim.log.levels.ERROR)
                return
            end
            if chunk then
                result = result .. chunk
            end
        end)

        vim.wait(1000, function()
            return result ~= ''
        end)

        handle:close()

        vim.notify(result, nil, { title = 'Current document word count' })
    else
        vim.notify(string.format('texcount binary only supports latex subtypes. Filetype %s is unsupported', fs))
    end
end
return extensions
