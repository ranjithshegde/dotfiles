if vim.b.current_syntax then
    return
else
    vim.b.current_syntax = 'LspCapabilities'
    vim.cmd 'syntax clear'

    local ok, parse = pcall(require, 'nvim-treesitter.parsers')
    if ok then
        parse.filetype_to_parsername.LspCapabilities = 'markdown'
    else
        vim.cmd 'syntax include @markdown syntax/markdown.vim'
    end
end
