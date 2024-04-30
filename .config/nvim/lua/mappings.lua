local utils = require("utils")
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line mover
map({'n', 'i'}, "<C-Up>", function()
    utils.switch_line(-1)
end)
map({'n', 'i'}, "<C-Down>", function()
    utils.switch_line(1)
end)

-- save file
map({'n'}, "<C-s>", "<cmd>w<CR>")

-- nvim-tree
map({'n'}, "<leader>t", "<cmd>NvimTreeToggle<CR>")
map({'n'}, "<leader>tt", "<cmd>NvimTreeFocus<CR>")

-- lazy
-- yeah lazy
map({'n'}, "<leader>l", "<cmd>Lazy<CR>")

-- telescope
local telescope = require('telescope.builtin')
map({'n'}, "<leader>f", telescope.current_buffer_fuzzy_find)
map({'n'}, "<leader>ff", telescope.find_files)
map({'n'}, "<leader>fff", telescope.live_grep)
