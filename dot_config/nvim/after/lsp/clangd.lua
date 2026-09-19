local cmd = {
    'clangd',
    '--clang-tidy',
    '--background-index',
    '--all-scopes-completion',
    '--completion-style=detailed',
    '--fallback-style=webkit',
    '--offset-encoding=utf-32',
    '--header-insertion=never',
    '--function-arg-placeholders=1',
}

return {
    filetypes = { 'c', 'cpp', 'opencl' },
    init_options = {
        clangdFileStatus = true,
    },
    cmd = cmd,
}
