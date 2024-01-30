-- https://github.com/nvim-telescope/telescope.nvim/issues/179
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		--layout_strategy = "bottom_pane",
		--layout_config = {
		--	height = 0.4,
		--},
		--border = true,
		--sorting_strategy = "ascending",
	},
	pickers = {
		buffers = {
			sort_lastused = true,
			ignore_current_buffer = true,
		},
		lsp_references = {
			show_line = false,
		},
		git_files = {
			use_git_root = false,
		},
	},
	mappings = {
		i = {
			["<C-j>"] = actions.move_selection_next,
			["<C-k>"] = actions.move_selection_previous,
		},
	},
})

--require('telescope').load_extension('fzy_native')
require("telescope").load_extension("fzf")
