return {
    desc = "Save file before executing",
    params = {},
    editable = false,
    constructor = function(params)
        return {
            on_pre_start = function(self, task)
                vim.cmd.w()
            end,
        }
    end,
}
