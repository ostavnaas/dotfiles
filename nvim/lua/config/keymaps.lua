vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.timeoutlen = 1000

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>dd", ":%bd|e#<CR>", opts)
vim.keymap.set("n", "<leader>da", ":%bd|e#'<CR>", opts)
