------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------
require("el").reset_windows()

local builtin = require("el.builtin")
local extensions = require("el.extensions")
local sections = require("el.sections")
local subscribe = require("el.subscribe")
local lsp_statusline = require("el.plugins.lsp_status")
local colors = Colors
local separators = {left = "  ", right = "  "}

--*********************************** File Icon ---------------------------------
local file_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
	local icon = extensions.file_icon(_, bufnr)
	if icon then
		return icon .. " "
	end
	return ""
end)

local colors = {
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


--*********************************** Vim Mode ---------------------------------
local mode = function()
	local alias = {
		n = '  ☉ ',
		i = '  ✎ ',
		c = '  ⌨ ',
		v = '  ✄ ',
		[''] = '  ✄ ',
		t = 'zsh  ▧ '
	}

	local mode_color = {
		n = colors.blue,
		i = colors.orange,
		c = colors.yellow,
		v = colors.cyan,
		[''] = colors.cyan,
		t = colors.purple
	}
	-- Text for mode
	local current_mode = alias[vim.fn.mode()]
	-- Get color for mode
	local current_bg = mode_color[vim.fn.mode()]
	local current_fg = colors.white
	-- Set color
	vim.cmd(string.format('hi GalaxyViMode guibg=%s guifg=%s', current_bg, current_fg))
	return current_mode
end

--*********************************** Scroll position ---------------------------------
local scroll = function()
	local current_line = vim.fn.line('.')
	local total_lines = vim.fn.line('$')
	local default_chars = {
		-- '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██'
		'_', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'
	}
	local chars = default_chars
	local index = 1

	if current_line == 1 then
		index = 1
	elseif current_line == total_lines then
		index = #chars
	else
		local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
		index = vim.fn.float2nr(line_no_fraction * #chars)
		if index == 0 then
			index = 1
		end
	end
	vim.cmd(string.format('hi MyScroll guibg=%s guifg=%s', colors.yellow, colors.purple))
	return chars[index]
end

--*********************************** SuperCollider ---------------------------------
local scnvim = function()
	local scstatus = "📡" .. Fn("scnvim#statusline#server_status", {})
	vim.cmd(string.format('hi SuperC guibg=%s guifg=%s', colors.blue, colors.bg))
	if Op("filetype") == "supercollider" then
		return scstatus
	end
end

--*********************************** TreeSitter ---------------------------------
-- local scContext = function()
--     if Op("filetype") == "supercollider" then
--     return Api.nvim_exec([[
--      echo nvim_treesitter#statusline(90)
-- module->expression_statement->call->identifier]], false)
--     end
-- end

--*********************************** Git branch ---------------------------------
local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
	local branch = extensions.git_branch(window, buffer)
	vim.cmd(string.format('hi MyGit guibg=%s guifg=%s', colors.bg, colors.yellow))
	if branch then
		return " " .. "" .. " " .. branch
	end
end)

--*********************************** GitSigns changes ---------------------------------
local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost", function(window, buffer)
	vim.cmd(string.format('hi MyDiff guibg=%s guifg=%s', colors.bg, colors.blue))
	return extensions.git_changes(window, buffer)
end)

--*********************************** Status config ---------------------------------
require("el").setup({
	generator = function(_, _)
		return {
			sections.highlight("GalaxyViMode", mode),
			sections.highlight("MyGit", git_branch),
			separators.left,
			sections.highlight("MyDiff", git_changes),
			separators.left,
			sections.split,
			sections.highlight("Diag", lsp_statusline.segment),
			sections.split,
			-- sections.highlight("Diag", scContext),
			sections.highlight("SuperC", scnvim),
			lsp_statusline.server_progress,
			sections.split,
			sections.highlight("DevIconH", file_icon),
			sections.highlight("Filename", builtin.tail_file),
			sections.collapse_builtin({" ", builtin.modified_flag}),
			separators.right,
			-- builtin.quickfix,
			-- builtin.preview,
			builtin.line_with_width(3), ":", builtin.column_with_width(2),
			separators.left,
			sections.highlight("MyGit", builtin.percentage_through_file),
			sections.highlight("MyScroll", scroll),
			sections.collapse_builtin({builtin.help_list, builtin.readonly_list})
		}
	end
})

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------

local M = {}
-- Separators
local left_separator = ''
local right_separator = ''
-- Blank Between Components
local space = ' '

--*********************************** Working Dir ---------------------------------
local workDir = function()
	local home = vim.call("expand", "%")
	return home
end

--*********************************** File label ---------------------------------
local getTabLabel = function(n)
	local current_win = Api.nvim_tabpage_get_win(n)
	local current_buf = Api.nvim_win_get_buf(current_win)
	local file_name = Api.nvim_buf_get_name(current_buf)
	if string.find(file_name, 'term://') ~= nil then
		return ' ' .. Api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
	end
	file_name = Api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
	if file_name == '' then
		return "No Name"
	end

	local ext = vim.fn.fnamemodify(file_name, ':e')
	local icon = require'nvim-web-devicons'.get_icon(file_name, ext)
	if icon ~= nil then
		return icon .. space .. file_name
	end
	return file_name
end

--*********************************** Highlight groups ---------------------------------
local set_colours = function()
	-- SET TABLINE COLOURS
	Exec('hi TabLineSel gui=Bold guibg=#8ec07c guifg=#292929')
	Exec('hi TabLineSelSeparator gui=bold guifg=#8ec07c')
	Exec('hi TabLine guibg=#504945 guifg=#b8b894 gui=None')
	Exec('hi TabLineSeparator guifg=#504945')
	Exec('hi TabLineFill guibg=None gui=None')
end

--*********************************** Tabline module ---------------------------------
function M.init()
	set_colours()
	local tabline = ''
	local tab_list = Api.nvim_list_tabpages()
	local current_tab = Api.nvim_get_current_tabpage()
	for _, val in ipairs(tab_list) do
		local file_name = getTabLabel(val)
		if val == current_tab then
			tabline = tabline .. "%#TabLineSelSeparator# " .. left_separator
			tabline = tabline .. "%#TabLineSel# " .. file_name
			tabline = tabline .. " %#TabLineSelSeparator#" .. right_separator
		else
			tabline = tabline .. "%#TabLineSeparator# " .. left_separator
			tabline = tabline .. "%#TabLine# " .. file_name
			tabline = tabline .. " %#TabLineSeparator#" .. right_separator
		end
	end
	tabline = tabline .. "%="
	-- Component: Working Directory
	tabline = tabline .. "%#TabLineSeparator#" .. left_separator .. "%#Tabline# " .. workDir() ..
		"%#TabLineSeparator#" .. right_separator
	tabline = tabline .. space
	return tabline
end
return M
