--[[ lazy ]]--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
lazy.setup {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false
    },
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.6",
        dependencies = {"nvim-lua/plenary.nvim"}
    },
    {"NvChad/nvim-colorizer.lua"},
    {"RRethy/base16-nvim"}
}

-- plugins
require("nvim-tree").setup()
require("colorizer").setup()

--[[ keymapping ]]--
require("mappings")

--[[ common settings ]]--
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
vim.cmd.colorscheme "base16-gruvbox-dark-medium"

-- disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
