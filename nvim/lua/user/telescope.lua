-- https://github.com/nvim-telescope/telescope.nvim/issues/179
local actions = require('telescope.actions')require('telescope').setup{
  pickers = {
    buffers = {
      sort_lastused = true
    }
  }
}
