local startup = {
    -- every line should be same width without escaped \
    header = {
        type = "text",
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 5,
        content = require("startup.headers").neovim_banner_header,
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    quote = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Quote",
        margin = 5,
        content = require("startup.functions").quote(),
        highlight = "Constant",
        default_color = "",
        oldfiles_amount = 0,
    },

    instruction = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Navigate",
        margin = 5,
        content = { "Navigate to a line and press <Tab> to toggle instructions" },
        highlight = "Constant",
        default_color = "",
        oldfiles_amount = 0,
    },
    body = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = true,
        title = "Launch Telescope",
        margin = 0,
        content = {
            "Press <Space> to Launch Telescope, explore Which-key guide for further options",
            "<Space>f prefix opens find_file options",
            "<Space>g prefix opens live_grep options",
            "<Space>G prefix opens git options",
        },
        highlight = "String",
        default_color = "#FFFFFF",
        oldfiles_amount = 0,
    },

    body_2 = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = true,
        title = "Project Configuration",
        margin = 0,
        content = {
            "Press <leader>aot and navigate to function telescope()",
            "Configure your project path in `setup.extensions.project.base_dirs`",
            "Press <Space>p to launch the browser",
        },
        highlight = "String",
        default_color = "#FFFFFF",
        oldfiles_amount = 0,
    },

    oldfiles = {
        type = "oldfiles",
        oldfiles_directory = false,
        align = "center",
        fold_section = true,
        title = "Oldfiles",
        margin = 5,
        content = { "startup.nvim" },
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 5,
    },

    footer = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Create project",
        margin = 5,
        content = {
            "Type :Project to create a new project for chosen type",
            "Type :Scratch to create a new ScratchPad for chosen type",
        },
        highlight = "Type",
        default_color = "#FFFFFF",
        oldfiles_amount = 0,
    },

    clock = {
        type = "text",
        content = function()
            local clock = " " .. os.date "%H:%M"
            local date = " " .. os.date "%d-%m-%y"
            return { clock, date }
        end,
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },

    footer_2 = {
        type = "text",
        content = require("startup.functions").packer_plugins(),
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },

    options = {
        after = function()
            require("startup.utils").oldfiles_mappings()
        end,
        mapping_keys = true,
        cursor_column = 0.5,
        empty_lines_between_mappings = true,
        disable_statuslines = true,
        paddings = { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 },
    },
    mappings = {
        execute_command = "<CR>",
        open_file = "o",
        open_file_split = "<c-o>",
        open_section = "<TAB>",
        open_help = "?",
    },
    colors = {
        background = "#1f2227",
        folded_section = "#56b6c2",
    },
    parts = {
        "quote",
        "header",
        "instruction",
        "body",
        "body_2",
        "oldfiles",
        "footer",
        "clock",
        "footer_2",
    },
}
return startup
