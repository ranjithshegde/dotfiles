local tables = {}

------------------------------------------------------------------------
--                              FileTypes                             --
------------------------------------------------------------------------
---Filetypes with Language Servers
tables.lspfiles = {
    'bash',
    'sh',
    'zsh',
    'tex',
    'bib',
    'css',
    'cmake',
    'c',
    'cs',
    'cpp',
    'glsl',
    'objc',
    'opencl',
    'dart',
    'html',
    'javascript',
    'typescript',
    'java',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'org',
    'python',
    'rust',
    'toml',
    'yaml',
    'java',
}

tables.projectTypes = {
    'cpp',
    'dart',
    'electronics',
    'lua',
    'js',
    'perl',
    'python',
    'supercollider',
    'website',
}

---Filetypes that are read-only
tables.ignoreFiles = {
    '',
    'qf',
    'man',
    'lazy',
    'help',
    'noice',
    'netrw',
    'scnvim',
    'Outline',
    'lspinfo',
    'NodeTree',
    'WhichKey',
    'checkhealth',
    'null-ls-info',
    'DressingInput',
    'TelescopePrompt',
    'TelescopeResults',
}

tables.ignore_binaries = {
    '%.jpeg',
    '%.MOV',
    '%.mov',
    '%.mp4',
    '%.wav',
    '%.WAV',
    '%.mkv',
    '%.gif',
    '%.mp3',
    '%.m4a',
    '%.png',
    '%.svg',
    '%.jpg',
    '%.au',
}

tables.ignore_binaries_regex = {
    '*.png',
    '*.svg',
    '*.PNG',
    '*.jpg',
    '*.pdf',
    '*.gif',
    '*.jpeg',
    '*.svg',
    '*.odt',
    '*.doc*',
    '*.rtf',
    '*.wav',
}

------------------------------------------------------------------------
--                              Symbols                               --
------------------------------------------------------------------------

--- Lsp Kind Icons
tables.kindSymbols = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Field = '',
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
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
}

-- associate icons with nodes
tables.tsNodeSymbols = {
    class = ' ',
    ['function'] = ' ',
    function_definition = ' ',
    method = 'ƒ ',
    struct = ' ',
    table_constructor = ' ',
    object = ' ',
    enum = '了 ',
    interface = 'ﰮ ',
    module = ' ',
    require = ' ',
    type_spec = ' ',
    pair = ' ',
    chapter = ' ',
    subsection = ' ',
    section = ' ',
    linkage_specification = ' ',
}

---TreeSitter nodes selection
tables.tsNodes = {
    --- Default fallback
    default = {
        'class',
        'function',
        'method',
        'struct',
        'enum',
        'interface',
        'module',
        'type_spec',
        'section',
    },
    ---per filetype
    filetype = {

        c = {
            'function',
            'function_definition',
            'struct',
            'enum',
            'linkage_specification',
            'if_statement',
            'for_statement',
        },
        cpp = {
            'class',
            'function',
            'function_definition',
            'struct',
            'enum',
            'if_statement',
            'for_statement',
            'linkage_specification',
        },
        cmake = {
            'identifier',
            'normal_command',
            'argument',
            'unquoted_argument',
        },
        json = {
            'object',
            'pair',
            'key',
            'value',
        },
        lua = {
            'function',
            'table_constructor',
            'module',
            'enum',
        },
        opencl = {
            'function_definition',
            'struct',
            'enum',
            'linkage_specification',
        },
        tex = {
            'chapter',
            'subsection',
            'section',
        },
    },
}

------------------------------------------------------------------------
--                              Plugin lists                          --
------------------------------------------------------------------------

--- CUrrent context for indent blankline
tables.indentContext = {
    '^for',
    '^case',
    'block',
    '^table',
    'return',
    '^while',
    '^public',
    '^switch',
    '^object',
    'inherits',
    '^private',
    '^protected',
    'jsx_element',
    'jsx_element',
    'else_clause',
    'if_statement',
    'catch_clause',
    'try_statement',
    'operation_type',
    'access_specifier',
    'import_statement',
    'jsx_self_closing_element',
}

--- disable builtin vim plugins
tables.rtp = {
    'fzf',
    'tar',
    'zip',
    'gzip',
    'shada',
    'tutor',
    'tohtml',
    'matchit',
    'rplugin',
    'spellfile',
    'tarPlugin',
    'zipPlugin',
    'matchparen',
    'netrwPlugin',
}

--- TreeSitter parsers to keep installed
tables.ts_parsers = {
    'bash',
    'bibtex',
    'c',
    'cmake',
    'cpp',
    'comment',
    'css',
    'dart',
    'glsl',
    'help',
    'html',
    'java',
    'javascript',
    'json',
    'latex',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'org',
    'perl',
    'python',
    'query',
    'regex',
    'scheme',
    'supercollider',
    'toml',
    'vim',
    'yaml',
}

return tables
