vim.bo.commentstring = '//%s'

if vim.bo.filetype == 'cpp' then
    local buffer = vim.api.nvim_get_current_buf()
    require('r.mappings.util').cpp_ref(buffer)
    require('r.extensions.project.detection').setup(buffer)
end
