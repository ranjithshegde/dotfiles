local side_width = 40

local sidebar_preview = {
    type = 'float',
    relative = 'editor',
    anchor = 'NW',
    position = {
        math.floor(0),
        math.floor(vim.o.columns - side_width - math.floor(vim.o.columns * 0.3)),
    },
    size = {
        width = math.floor(vim.o.columns * 0.3),
        height = math.floor(vim.o.lines * 0.4),
    },
    border = 'rounded',
    title = 'Preview',
    title_pos = 'center',
    zindex = 200,
}

local float_win = {
    type = 'float',
    relative = 'cursor',
    border = 'single',
    position = { 0, 0 },
    size = {
        width = math.floor(vim.o.columns * 0.3),
        height = math.floor(vim.o.lines * 0.3),
    },
}

local float_preview = {
    type = 'float',
    relative = 'win',
    anchor = 'NW',
    position = { 0, float_win.size.width + 2 },
    size = {
        width = math.floor(vim.o.columns * 0.5),
        height = math.floor(vim.o.lines * 0.5),
    },
    border = 'rounded',
}

local float_conf = {
    auto_jump = false,
    win = float_win,
    focus = true,
    preview = float_preview,
}

return {
    modes = {
        lsp = {
            win = {
                position = 'right',
                size = { width = side_width },
            },
            preview = sidebar_preview,
        },
        symbols = { win = { position = 'left' } },
        lsp_references = float_conf,
        lsp_definitions = float_conf,
        lsp_type_definitions = float_conf,
    },
}
