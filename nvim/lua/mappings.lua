require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Oil keymap
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Inc-Rename
map("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand "<cword>"
end, { expr = true })

--== My custom NeoVim remaps ==--
map({ "n", "v" }, "<leader>Q", "<cmd>q<cr>", { desc = "Close damn buffer" })
map({ "n", "v" }, "H", "g^", { desc = "Easy Beginning of Line" })
map({ "n", "v" }, "L", "g$", { desc = "Easy End of Line" })
map({ "n", "v" }, "j", "gj", { desc = "Visual Down 1 Line" })
map({ "n", "v" }, "k", "gk", { desc = "Visual Up 1 Line" })
map({ "n", "v" }, "M", "%", { desc = "Jump between open and closing (), [], and {}" })
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>")
-- ======================== --

-- ScreenKey Toggle
map({ "n" }, "<leader>sk", "<cmd>Screenkey<cr>", { desc = "Start showing keystrokes" })

-- ZenMode
map("n", "<leader>ze", "<CMD>ZenMode<CR>", { desc = "ZenMode Enable" })

-- MoveLine mappings
local moveline = require "moveline"
map("n", "<Esc>k", moveline.up)
map("n", "<Esc>j", moveline.down)
map("v", "<Esc>k", moveline.block_up)
map("v", "<Esc>j", moveline.block_down)

-- Open a term quickly
map("n", "<leader>T", "<CMD>term<CR>", { desc = "Open the term FAST" })

-- Open Lazy & Mason Panel
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy Panel" })
map("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason Panel" })

-- Nvim-Spider mappings
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- Smart-Splits mappings

-- resizing splits w/Lua Require === NOT WORKING
-- these keymaps will also accept a range,
map("n", "<A-h>", "SmartResizeLeft", { desc = "" })
map("n", "<A-j>", "<cmd>lua require('smart-splits').resize_down()<cr>", { desc = "" })
map("n", "<A-k>", "<cmd>lua require('smart-splits').resize_up()<cr>", { desc = "" })
map("n", "<A-l>", "<cmd>lua require('smart-splits').resize_right()<cr>", { desc = "" })
-- moving between splits
map("n", "<C-h>", "<CMD>SmartCursorMoveLeft<CR>", { silent = true })
map("n", "<C-j>", ":SmartCursorMoveDown<CR>", { silent = true })
map("n", "<C-k>", ":SmartCursorMoveUp<CR>", { silent = true })
map("n", "<C-l>", ":SmartCursorMoveRight<CR>", { silent = true })

-- swapping buffers between windows
map("n", "<leader><leader>h", "<cmd>lua require('smart-splits').swap_buf_left()<cr>", { desc = "" })
map("n", "<leader><leader>j", "<cmd>lua require('smart-splits').swap_buf_down()<cr>", { desc = "" })
map("n", "<leader><leader>k", "<cmd>lua require('smart-splits').swap_buf_up()<cr>", { desc = "" })
map("n", "<leader><leader>l", "<cmd>lua require('smart-splits').swap_buf_right()<cr>", { desc = "" })
