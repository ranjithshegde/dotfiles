local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
local configs = require "lspconfig.configs"

local supercollider = {
    default_config = {
        cmd = { "sclang-lsp-stdio.mjs", "sclang" },
        filetypes = { "supercollider" },
        root_dir = util.root_pattern "git" or vim.loop.cwd(),
        single_file_support = true,
        settings = {},
    },
    docs = {
        description = [[https://github.com/scztt/vscode-supercollider]],
    },
}

local sclang = {}

function sclang.init()
    if not configs.supercollider then
        require("lspconfig.configs").supercollider = supercollider
    end
    lspconfig.supercollider.setup { on_attach = require("lsp").attach }
end

return sclang
