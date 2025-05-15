local trouble = {}

local side_width = 40

local function float_win()
    return {
        type = 'float',
        relative = 'cursor',
        position = { 0, 0 },
        size = {
            width = math.floor(vim.o.columns * 0.25),
            height = math.floor(vim.o.lines * 0.25),
        },
    }
end

local function float_preview()
    local floating = float_win()
    local padding = 1

    local remaining_width =
        math.floor(vim.api.nvim_win_get_width(0) - (vim.api.nvim_win_get_cursor(0)[2] + floating.size.width + padding))

    return {
        type = 'float',
        relative = 'win',
        anchor = 'NW',
        position = { 0, floating.size.width + 1 },
        size = {
            width = remaining_width,
            height = math.floor(vim.o.lines * 0.7),
        },
        zindex = 200,
    }
end

function trouble.call(action, mode, float)
    local opts = { mode = mode }
    if float then
        opts.auto_jump = false
        opts.win = float_win()
        opts.focus = true
        opts.preview = float_preview()
    end
    require('trouble')[action](opts)
end

function trouble.init()
    local id = { Trouble = vim.api.nvim_create_augroup('Trouble', { clear = true }) }

    vim.keymap.set('n', '-', function()
        trouble.call('toggle', 'qflist')
    end, { desc = 'Toggle qflist' })
    vim.keymap.set('n', '_', function()
        trouble.call('toggle', 'loclist')
    end, { desc = 'Toggle loclist' })

    vim.api.nvim_create_autocmd('BufRead', {
        group = id.Trouble,
        callback = function(args)
            local type = vim.bo[args.buf].buftype
            if type == 'quickfix' then
                vim.schedule(function()
                    vim.cmd.cclose()
                    trouble.call('toggle', 'qflist')
                end)
            elseif type == 'loclist' then
                vim.schedule(function()
                    vim.cmd.lclose()
                    trouble.call('toggle', 'loclist')
                end)
            end
        end,
    })

    require('r.utils').register_au_id(id)
end

function trouble.config()
    return {
        modes = {
            lsp = {
                win = {
                    position = 'right',
                    size = { width = side_width },
                },
            },
            symbols = { win = { position = 'left' } },
        },
    }
end

return trouble
