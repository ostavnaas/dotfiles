vim.cmd.set('termguicolors')
vim.cmd.set('number')
vim.cmd.colorscheme('tender')
vim.cmd.set('mouse=')

vim.g.python3_host_prog = '~/python3/nvim/.venv/bin/python3'
--- keymaps must be at top
require "user.keymaps"
require "user.plugins"
require "user.coc"
-- require "user.lspconfig"
-- require "user.cmp"
require "user.nullis"
require "user.feline"
require "user.indent"
require "user.gitsigns"
require "user.auto-session"
require "user.telescope"
