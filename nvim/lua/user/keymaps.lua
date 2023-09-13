local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.timeoutlen = 1000

-- junegunn/fzf.vim
-- keymap('n', '<leader>b', ':Buffers <CR>', opts)
-- keymap('n', '<leader>m', ':GFiles <CR>', opts)
-- keymap('n', '<leader>h', ':History <CR>', opts)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>m',  builtin.git_files, {})
vim.keymap.set('n', '<leader>c',  builtin.git_status, {})
