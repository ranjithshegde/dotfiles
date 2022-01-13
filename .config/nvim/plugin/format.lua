-- vim.o.formatoptions = {
--     a = false, -- Dont format pasted code
--     t = false, -- Delegate to linter prgs/LSP
--     o = false, -- O and o don't continue comments
--     r = false, -- Return does not continue comments
--     c = true, -- comments respect textwidth
--     q = true, -- Allow formatting comments w/ gq
--     n = true, -- Recognize numbered lists
--     j = true, -- Auto-remove comments if possible.
--     ["2"] = true, -- Indent according to 2nd line
-- }

vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Dont format pasted code
    - "t" -- Delegate to linter prgs/LSP
    - "o" -- O and o don't continue comments
    - "r" -- Return does not continue comments
    + "c" -- comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    + "n" -- Recognize numbered lists
    + "j" -- Auto-remove comments if possible.
    + "2" -- Indent according to 2nd line
