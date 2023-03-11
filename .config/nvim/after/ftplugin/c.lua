vim.bo.commentstring = '//%s'
require('r.mappings.language').cpp(vim.api.nvim_get_current_buf())

if vim.bo.filetype == 'c' then
    require('r.extensions.cpp').set_ctype()
end
