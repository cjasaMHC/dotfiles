require "nvchad.options"
local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

o.clipboard = ""
o.mouse = ""

vim.opt.relativenumber = true

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=600})
augroup END
]]

