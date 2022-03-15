local Telescope = {}

------------------------------------------------------------------------
--                       Telescope 									  --
------------------------------------------------------------------------

function Telescope.telescope()
    require("telescope").setup {
        pickers = {
            find_files = { follow = true },
            buffers = {
                sort_mru = true,
                sort_lastused = true,
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
                                        local new_buf = vim.F.if_nil(
                                            table.remove(replacement_buffers),
                                            vim.api.nvim_create_buf(false, true)
                                        )
                                        vim.api.nvim_win_set_buf(winid, new_buf)
                                    end
                                end
                                vim.api.nvim_buf_delete(bufnr, { force = true })
                            end)
                        end,
                    },
                },
            },
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
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            file_ignore_patterns = {
                "%.MOV",
                "%.mov",
                "%.mp4",
                "%.wav",
                "%.WAV",
                "%.mkv",
                "%.gif",
                "%.mp3",
                "%.m4a",
                "%.au",
            },
        },
    }
end

return Telescope
