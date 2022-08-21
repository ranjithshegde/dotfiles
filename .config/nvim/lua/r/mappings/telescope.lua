------------------------------------------------------------------------
--                              Telescope                             --
------------------------------------------------------------------------

local cd_files = function(...)
    local args = { ... }
    return function()
        require("r.settings.telescope").cdFiles(args[1], args[2])
    end
end

local cd_browser = function(...)
    local args = { ... }
    return function()
        require("r.settings.telescope").cdBrowser(args[1], args[2])
    end
end

local tele = function(name)
    return function()
        require("telescope.builtin")[name]()
    end
end

local telargs = function(name, args)
    return function()
        require("telescope.builtin")[name](args)
    end
end

local tel_ext = function(name, args)
    return function()
        require("telescope").extensions[name][name](args)
    end
end

return require("which-key").register {
    ["<Space>"] = {
        name = "Telescope",
        b = { tele "buffers", "Buffers" },
        c = { tele "commands", "Vim commands" },
        C = { tele "command_history", "Command history" },
        h = { tele "highlight", "Highlights" },
        j = { tele "jumplist", "Jump history" },
        l = { tele "loclist", "local quickfix list" },
        m = { tele "symbols", "Unicode characters" },
        o = { cd_files("Org files", "~/Documents/Orgs"), "Org files" },
        O = { tele "vim_options", "Vim options" },
        q = { tele "quickfix", "Quickfix list" },
        r = { tele "lsp_references", "Lsp References" },
        R = { tele "reloader", "Reload lua modules" },
        s = { tele "lsp_document_symbols", "Lsp symbols in buffer" },
        S = { tele "lsp_dynamic_workspace_symbols", "Grep lsp workspace symbols" },
        t = {
            name = "Treesitter",
            n = { tele "treesitter", "TreeSitter nodes in buffer" },
            f = {
                "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
                "Treesitter Refactoring options",
                mode = "v",
            },
        },
        T = { tele "tagstack", "Lsp Ctags" },
        z = { tele "current_buffer_fuzzy_find", "Fuzzy find in buffer" },
        ["'"] = { tele "marks", "Marks" },
        ['"'] = { tele "registers", "Registers" },
        ["="] = { tele "spell_suggest", "Spell suggest" },
        ["/"] = { tele "grep_string", "Grep CWORD in directory" },
        ["]"] = { tele "tags", "Lsp Ctags" },
        ["<Space>"] = { tele "builtin", "Builtin Searchers" },
        ["<CR>"] = { tele "resume", "Resume last picker" },
        k = { telargs("lsp_workspace_symbols", { query = vim.fn.expand "<cword>" }), "Search lsp workspace symbol" },
        p = { tel_ext("project", { display_type = "full" }), "Projects" },
        e = { tel_ext("file_browser", { files = false }), "Folder browser" },
        E = { tel_ext "file_browser", "File browser" },
        d = {
            name = "diagnostics",
            b = { tele "diagnostics", "buffer diagnostics" },
            w = { tele "diagnostics", "Workspace diagnostics" },
        },
        G = {
            name = "git commands",
            b = { tele "git_branches", "Branches" },
            c = { tele "git_commits", "Commit history" },
            s = { tele "git_status", "Status" },
            f = { tele "git_files", "Tracked files" },
        },
        g = {
            name = "Live grep in",
            g = { tele "live_grep", "current directory" },
            s = {
                telargs(
                    "live_grep",
                    { cwd = "~/Software/Workspaces/supercollider/", prompt_title = "SuperCollider Workspace grep" }
                ),
                "grep SuperCollider",
            },
            o = {
                telargs(
                    "live_grep",
                    { cwd = "~/Software/Workspaces/openFrameworks/", prompt_title = "oF Workspace grep" }
                ),
                "ofWorkspace",
            },
            d = {
                telargs("live_grep", { cwd = "~/.config", prompt_title = "Dotfiles" }),
                "grep dotfiles",
            },
            ["?"] = {
                function()
                    require("telescope.builtin").live_grep {
                        cwd = vim.fn.input { prompt = "Enter directory: ", completion = "dir" },
                    }
                end,
                "Choose directory",
            },
            ["."] = {
                telargs("live_grep", {
                    cwd = "~/.config/nvim",
                    search_dirs = { "init.lua", "lua", "after", "plugin", "ftdetect" },
                    prompt_title = "vim config",
                }),
                "grep dotfiles",
            },
        },
        F = { tele "find_files", "Current directory" },
        f = {
            name = "find files in",
            f = { tele "find_files", "Current directory" },
            F = { telargs("find_files", { cwd = vim.fn.expand "%:p:h" }), "Home directory" },
            h = { telargs("find_files", { cwd = "~" }), "Home directory" },
            r = { tele "oldfiles", "Vim recent files" },
            R = { telargs("find_files", { cwd = "/usr/share/nvim/runtime/" }), "Vim runtime files" },
            t = { tele "help_tags", "vim help files" },
            C = { cd_files("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
            c = { cd_browser("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
            s = { cd_files("SuperCollider Directory", "~/Software/Workspaces/supercollider/"), "SuperCollider files" },
            b = {
                telargs("find_files", { cwd = "~/.local/bin/", prompt_title = "Scripts and binaries in local" }),
                "scripts & binaries",
            },
            d = {
                telargs(
                    "find_files",
                    { cwd = "~/.config/", find_command = { "fd", "--hidden" }, prompt_title = "Dotfiles" }
                ),
                "Dotfiles",
            },
            V = { cd_browser("Vim plugins", "~/.local/share/nvim/site/pack/packer/"), "Vim plugin Directory" },
            v = {
                telargs("find_files", { cwd = "~/.local/share/nvim/site/pack/packer", prompt_title = "Plugin files" }),
                "Vim plugin Directory",
            },
            o = {
                telargs(
                    "find_files",
                    { cwd = "~/Software/Workspaces/openFrameworks/", prompt_title = "oF Workspace files" }
                ),
                "OfWorkspace",
            },
            ["?"] = {
                function()
                    require("telescope.builtin").find_files {
                        cwd = vim.fn.input { prompt = "Enter directory: ", completion = "dir" },
                    }
                end,
                "Choose directory",
            },
            ["."] = {
                telargs("find_files", { cwd = "~/.config/nvim", prompt_title = "Neovim configuration files" }),
                "Neovim config files",
            },
        },
        a = { vim.cmd.OverseerQuickAction, "Action list" },
    },
}
