vim.cmd.set("termguicolors")
vim.cmd.set("number")
vim.cmd.colorscheme("tender")
vim.cmd.set("mouse=")

vim.g.python3_host_prog = "~/.config/nvim/.venv/bin/python3"
--- keymaps must be at top
require("user.keymaps")
require("user.plugins")
--require "user.coc"
require("user.telescope")
require("user.lspconfig")
-- require("user.mason")
require("user.cmp")
require("user.nullis")
require("user.feline")
require("user.indent")
require("user.gitsigns")
require("user.auto-session")
