local foldMaps = function(_, _)
    require("telescope.actions.set").select:enhance {
        post = function()
            vim.cmd.normal { args = { "zx" }, bang = true }
        end,
    }
    return true
end

local bufferPicker = {
    sort_mru = true,
    sort_lastused = true,
    attach_mappings = foldMaps,
    mappings = {
        i = {
            ["<C-x>"] = function(prompt_bufnr)
                local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local selected_bufnr = require("telescope.actions.state").get_selected_entry().bufnr

                local replacement_buffers = {}
                for entry in current_picker.manager:iter() do
                    if entry.bufnr < selected_bufnr then
                        table.insert(replacement_buffers, 1, entry.bufnr)
                    end
                end

                current_picker:delete_selection(function(selection)
                    local bufnr = selection.bufnr
                    local winids = vim.fn.win_findbuf(bufnr)
                    local tabwins = vim.api.nvim_tabpage_list_wins(0)
                    for _, winid in ipairs(winids) do
                        if vim.tbl_contains(tabwins, winid) then
                            local new_buf =
                                vim.F.if_nil(table.remove(replacement_buffers), vim.api.nvim_create_buf(false, true))
                            vim.api.nvim_win_set_buf(winid, new_buf)
                        end
                    end
                    vim.api.nvim_buf_delete(bufnr, { force = true })
                end)
            end,
        },
    },
}

local function navigate(prompt_bufnr, maps, cwd, files)
    local change_dir = function(window)
        local wd = require("telescope.actions.state").get_selected_entry().value
        require("telescope.actions.set").select(prompt_bufnr, window)
        if files then
            vim.fn.execute("tcd " .. cwd)
        end
        if not require("plenary.path"):new(wd):is_dir() then
            local dir = vim.fn.fnamemodify(wd, ":p:h")
            vim.fn.execute("tcd " .. dir)
        end
    end
    maps("n", "<CR>", function()
        change_dir "default"
    end)
    maps("i", "<CR>", function()
        change_dir "default"
    end)
    maps("n", "<C-v>", function()
        change_dir "vertical"
    end)
    maps("i", "<C-v>", function()
        change_dir "vertical"
    end)
    maps("n", "<C-t>", function()
        change_dir "tab"
    end)
    maps("i", "<C-t>", function()
        change_dir "tab"
    end)
    return true
end

------------------------------------------------------------------------
--                       Telescope 									  --
------------------------------------------------------------------------

local telescope = {}

function telescope.cdBrowser(prompt, cwd)
    require("telescope").extensions.file_browser.file_browser {
        prompt_title = prompt,
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, maps)
            return navigate(prompt_bufnr, maps, cwd, false)
        end,
    }
end

function telescope.cdFiles(prompt, cwd)
    require("telescope.builtin").find_files {
        prompt_title = prompt,
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, maps)
            return navigate(prompt_bufnr, maps, cwd, true)
        end,
    }
end

function telescope.telescope()
    require("packer").loader "telescope-fzf-native.nvim"
    local layout_actions = require "telescope.actions.layout"
    require("telescope").setup {
        pickers = {
            buffers = bufferPicker,
            loclist = { theme = "ivy" },
            quickfix = { theme = "ivy" },
            lsp_document_symbols = { theme = "ivy" },
            lsp_workspace_symbols = { theme = "cursor" },
            current_buffer_fuzzy_find = { theme = "ivy" },
            lsp_references = { theme = "cursor" },
            oldfiles = { attach_mappings = foldMaps },
            git_files = { attach_mappings = foldMaps },
            live_grep = { attach_mappings = foldMaps },
            grep_string = { attach_mappings = foldMaps },
            find_files = { follow = true, attach_mappings = foldMaps },
        },
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "-L",
            },
            layout_strategy = "flex",
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            dynamic_preview_title = true,
            cycle_layout_list = { "vertical", "bottom_pane", "center", "flex" },
            file_ignore_patterns = require("r.utils.tables").ignore_binaries,
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                    ["<c-e>"] = layout_actions.toggle_preview,
                    ["<c-l>"] = layout_actions.cycle_layout_next,
                },
            },
        },
        extensions = {
            project = {
                base_dirs = {
                    { "~/Documents/LaTeX", max_depth = 3 },
                    { "~/Software/libraries/", max_depth = 2 },
                    { "~/Software/Workspaces/lua", max_depth = 4 },
                    { "~/Software/Workspaces/cpp", max_depth = 4 },
                    { "~/Software/Workspaces/Repos", max_depth = 4 },
                    { "~/Software/Workspaces/electronics", max_depth = 4 },
                    { "~/Software/Workspaces/openFrameworks", max_depth = 5 },
                    { "~/Software/Workspaces/websites/", max_depth = 3 },
                },
            },
            file_browser = { hijack_netrw = true },
        },
    }
    require("telescope").load_extension "fzf"
    if package.loaded.notify then
        require("telescope").load_extension "notify"
    end
end

return telescope
