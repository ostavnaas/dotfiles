local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.timeoutlen = 1000
vim.api.nvim_set_keymap('n', '<leader>dd', ':%bd|e#<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>da', ':%bd|e#\'<CR>', { noremap = true, silent = true })
