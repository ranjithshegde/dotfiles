vim.bo.commentstring = '//%s'

if vim.bo.filetype == 'c' then
    require('r.extensions.project.detection').setup(vim.api.nvim_get_current_buf())
end
