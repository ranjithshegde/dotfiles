local lspkind = {}
local fmt = string.format
local u = require('utils')

local extensionTable = {
    -- Exact Match
    ['gruntfile.coffee'] = '',
    ['gruntfile.js'] = '',
    ['gruntfile.ls'] = '',
    ['gulpfile.coffee'] = '',
    ['gulpfile.js'] = '',
    ['gulpfile.ls'] = '',
    ['mix.lock'] = '',
    ['dropbox'] = '',
    ['.ds_store'] = '',
    ['.gitconfig'] = '',
    ['.gitignore'] = '',
    ['.gitlab-ci.yml'] = '',
    ['.bashrc'] = '',
    ['.zshrc'] = '',
    ['.vimrc'] = '',
    ['.gvimrc'] = '',
    ['_vimrc'] = '',
    ['_gvimrc'] = '',
    ['.bashprofile'] = '',
    ['favicon.ico'] = '',
    ['license'] = '',
    ['node_modules'] = '',
    ['react.jsx'] = '',
    ['procfile'] = '',
    ['dockerfile'] = '',
    ['docker-compose.yml'] = '',
    -- Extension
    ['styl'] = '',
    ['sass'] = '',
    ['scss'] = '',
    ['htm'] = '',
    ['html'] = '',
    ['slim'] = '',
    ['ejs'] = '',
    ['css'] = '',
    ['less'] = '',
    ['md'] = '',
    ['mdx'] = '',
    ['markdown'] = '',
    ['rmd'] = '',
    ['json'] = '',
    ['js'] = '',
    ['mjs'] = '',
    ['jsx'] = '',
    ['rb'] = '',
    ['php'] = '',
    ['py'] = '',
    ['pyc'] = '',
    ['pyo'] = '',
    ['pyd'] = '',
    ['coffee'] = '',
    ['mustache'] = '',
    ['hbs'] = '',
    ['conf'] = '',
    ['ini'] = '',
    ['yml'] = '',
    ['yaml'] = '',
    ['toml'] = '',
    ['bat'] = '',
    ['jpg'] = '',
    ['jpeg'] = '',
    ['bmp'] = '',
    ['png'] = '',
    ['gif'] = '',
    ['ico'] = '',
    ['twig'] = '',
    ['cpp'] = '',
    ['c++'] = '',
    ['cxx'] = '',
    ['cc'] = '',
    ['cp'] = '',
    ['c'] = '',
    ['cs'] = '',
    ['h'] = '',
    ['hh'] = '',
    ['hpp'] = '',
    ['hxx'] = '',
    ['hs'] = '',
    ['lhs'] = '',
    ['lua'] = '',
    ['java'] = '',
    ['sh'] = '',
    ['fish'] = '',
    ['bash'] = '',
    ['zsh'] = '',
    ['ksh'] = '',
    ['csh'] = '',
    ['awk'] = '',
    ['ps1'] = '',
    ['ml'] = 'λ',
    ['mli'] = 'λ',
    ['diff'] = '',
    ['db'] = '',
    ['sql'] = '',
    ['dump'] = '',
    ['clj'] = '',
    ['cljc'] = '',
    ['cljs'] = '',
    ['edn'] = '',
    ['scala'] = '',
    ['go'] = '',
    ['dart'] = '',
    ['xul'] = '',
    ['sln'] = '',
    ['suo'] = '',
    ['pl'] = '',
    ['pm'] = '',
    ['t'] = '',
    ['rss'] = '',
    ['f#'] = '',
    ['fsscript'] = '',
    ['fsx'] = '',
    ['fs'] = '',
    ['fsi'] = '',
    ['rs'] = '',
    ['rlib'] = '',
    ['d'] = '',
    ['erl'] = '',
    ['hrl'] = '',
    ['ex'] = '',
    ['exs'] = '',
    ['eex'] = '',
    ['leex'] = '',
    ['vim'] = '',
    ['ai'] = '',
    ['psd'] = '',
    ['psb'] = '',
    ['ts'] = '',
    ['tsx'] = '',
    ['jl'] = '',
    ['pp'] = '',
    ['vue'] = '﵂',
    ['elm'] = '',
    ['swift'] = '',
    ['xcplayground'] = ''
}

lspkind.deviconTable = setmetatable(extensionTable, {
    __index = function(extensionTable, key)
        local i = string.find(key, '[.*]')
        if i ~= nil then
            return extensionTable[string.sub(key, i + 1)]
        end
    end
})

-- if you change or add symbol here
-- replace corresponding line in readme
local kind_symbols = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = ''
}

local kind_order = {
    'Text', 'Method', 'Function', 'Constructor', 'Field', 'Variable', 'Class', 'Interface',
    'Module', 'Property', 'Unit', 'Value', 'Enum', 'Keyword', 'Snippet', 'Color', 'File',
    'Reference', 'Folder', 'EnumMember', 'Constant', 'Struct', 'Event', 'Operator', 'TypeParameter'
}

Colors = {
    bg = '#32302f',
    bg2 = '#008080',
    bg3 = '#d79921',
    white = '#fbf1c7',
    yellow = '#d79921',
    cyan = '#008080',
    grey = '#928374',
    green = '#98971a',
    purple = '#b16286',
    orange = '#d65d0e',
    blue = '#458588',
    red = '#cc241d'
}

-- Api.nvim_exec([[
-- function! Cols() abort
-- endfunction
--   ]], true)

-- hi MyDiff guibg = lua Colors.bg guifg= lua Colors.blue
-- hi MyGit guibg = lua Colors.bg guifg= lua Colors.yellow
-- hi SuperC guibg= lua Colors.blue guifg= lua Colors.bg
-- hi MyScroll guibg= lua Colors.yellow guifg= lua Colors.purple

-- function _G.SetHighlights()
-- vim.cmd(string.format('hi MyDiff guibg=%s guifg=%s', Colors.bg, Colors.blue))
-- vim.cmd(string.format('hi MyGit guibg=%s guifg=%s', Colors.bg, Colors.yellow))
-- vim.cmd(string.format('hi SuperC guibg=%s guifg=%s', Colors.blue, Colors.bg))
-- vim.cmd(string.format('hi MyScroll guibg=%s guifg=%s', Colors.yellow, Colors.purple))
-- end

-- u.create_augroup({'ColorScheme * call Cols()'}, 'HiGroups')

function lspkind.init(opts)
    local with_text = opts == nil or opts['with_text']
    local symbol_map = (opts and opts['symbol_map'] and
                           vim.tbl_extend('force', kind_symbols, opts['symbol_map'])) or
                           kind_symbols

    local symbols = {}
    local len = 25
    if with_text == true or with_text == nil then
        for i = 1, len do
            local name = kind_order[i]
            local symbol = symbol_map[name]
            symbol = symbol and (symbol .. ' ') or ''
            symbols[i] = fmt('%s%s', symbol, name)
        end
    else
        for i = 1, len do
            local name = kind_order[i]
            symbols[i] = symbol_map[name]
        end
    end

    require('vim.lsp.protocol').CompletionItemKind = symbols
end

return lspkind
