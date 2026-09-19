local server = {}

function server.Start(name)
    local socket_path = '/tmp/nvim-' .. name .. '.sock'
    vim.fn.serverstart(socket_path)
    vim.notify('Neovim server started at: ' .. socket_path)
end

function server.Connect(name)
    local socket_path = '/tmp/nvim-' .. name .. '.sock'
    -- vim.fn.remote_startserver(socket_path)
    vim.fn.serverconnect(socket_path)
    vim.notify('Connecting to remove server at: ' .. socket_path)
end

return server
