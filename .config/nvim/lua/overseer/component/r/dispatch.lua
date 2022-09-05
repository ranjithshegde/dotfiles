return {
    desc = 'Default behaviours from `:compile` and `vim-dispatch`',
    params = {
        errorformat = {
            desc = 'See :help errorformat',
            type = 'string',
            optional = true,
        },
        save = { type = 'boolean', default = false, description = 'Save current file before executing task' },
        use_qf = {
            type = 'boolean',
            default = true,
            desc = "Parse task output using 'errorformat', set outout to qflist or dignostics",
        },
    },
    constructor = function(params)
        return {
            items = {},
            on_pre_start = function(self, task)
                if params.save then
                    vim.cmd.w()
                end
            end,
            on_start = function(self, task)
                if params.use_qf then
                    local qf = vim.fn.getqflist { id = 0, nr = '$' }
                    if qf then
                        vim.fn.setqflist({}, ' ', { title = task.name, context = task.name })
                    end
                end
            end,
            on_reset = function(self)
                self.items = {}
            end,
            on_output_lines = function(self, task, lines)
                if params.use_qf then
                    local qf = vim.fn.getqflist {
                        efm = params.errorformat,
                        lines = lines,
                    }
                    if qf.items then
                        vim.list_extend(self.items, qf.items)
                    end
                    vim.fn.setqflist({}, 'r', { items = self.items })
                    vim.cmd.copen()
                    vim.cmd.wincmd 'p'
                end
            end,
            on_pre_result = function(self, task)
                if not params.use_qf then
                    return { diagnostics = self.items }
                end
            end,
        }
    end,
}
