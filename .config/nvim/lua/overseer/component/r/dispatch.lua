return {
    desc = 'Default behaviours from `:compile` and `vim-dispatch`',
    params = {
        save = { type = 'boolean', default = false, description = 'Save current file before executing task' },
    },
    constructor = function(params)
        return {
            items = {},
            on_pre_start = function(_, _)
                if params.save then
                    vim.cmd.w()
                end
            end,
        }
    end,
}
