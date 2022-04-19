------------------------------------------------------------------------
--                              Telescope                             --
------------------------------------------------------------------------

local cd_files = require("settings.telescope").cdFiles
local cd_browser = require("settings.telescope").cdBrowser

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

return require("which-key").register {
    ["<Space>"] = {
        name = "Telescope",
        b = { tele "buffers", "Buffers" },
        c = { tele "commands", "Vim commands" },
        C = { tele "command_history", "Command history" },
        l = { tele "loclist", "local quickfix list" },
        m = { tele "symbols", "Unicode characters" },
        o = { cd_files("Org files", "~/Documents/Orgs"), "Org files" },
        q = { tele "quickfix", "Quickfix list" },
        r = { tele "lsp_references", "Lsp References" },
        s = { tele "lsp_document_symbols", "Lsp symbols in buffer" },
        S = { tele "lsp_dynamic_workspace_symbols", "Grep lsp workspace symbols" },
        t = { tele "tagstack", "Lsp Ctags" },
        T = { tele "treesitter", "TreeSitter nodes in buffer" },
        z = { tele "current_buffer_fuzzy_find", "Fuzzy find in buffer" },
        ["'"] = { tele "marks", "Marks" },
        ['"'] = { tele "registers", "Registers" },
        ["/"] = { tele "grep_string", "Grep CWORD in directory" },
        ["]"] = { tele "tags", "Lsp Ctags" },
        ["<Space>"] = { tele "builtin", "Builtin Searchers" },
        k = {
            function()
                require("telescope.builtin").lsp_workspace_symbols { query = vim.fn.expand "<cword>" }
            end,
            "Search lsp workspace symbol",
        },
        p = {
            function()
                require("telescope").extensions.project.project { display_type = "full" }
            end,
            "Projects",
        },
        e = {
            function()
                require("telescope").extensions.file_browser.file_browser { files = false }
            end,
            "Folder browser",
        },
        E = {
            function()
                require("telescope").extensions.file_browser.file_browser()
            end,
            "File browser",
        },
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
                    { cwd = "~/Documents/Supercollider/", prompt_title = "SuperCollider Workspace grep" }
                ),
                "grep SuperCollider",
            },
            o = {
                telargs("live_grep", { cwd = "~/Documents/ofWorkspace/", prompt_title = "oF Workspace grep" }),
                "ofWorkspace",
            },
            d = {
                telargs("live_grep", { cwd = "~/.config", prompt_title = "Dotfiles grep" }),
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
        },
        F = { tele "find_files", "Current directory" },
        f = {
            name = "find files in",
            f = { tele "find_files", "Current directory" },
            h = { telargs("find_files", { cwd = "~" }), "Home directory" },
            r = { tele "oldfiles", "Vim recent files" },
            t = { tele "help_tags", "vim help files" },
            C = { cd_files("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
            c = { cd_browser("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
            s = { cd_files("SuperCollider Directory", "~/Documents/Supercollider/"), "SuperCollider files" },
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
                telargs("find_files", { cwd = "~/Documents/ofWorkspace/", prompt_title = "oF Workspace files" }),
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
        },
    },
}
