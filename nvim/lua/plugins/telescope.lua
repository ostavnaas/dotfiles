-- https://github.com/nvim-telescope/telescope.nvim/issues/179
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
		tag = "0.1.5",

		init = function()
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
			require("telescope").load_extension("fzf")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>b", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			vim.keymap.set("n", "<leader>m", builtin.git_files, {})
			vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
			vim.keymap.set("n", "<leader>gc", builtin.git_branches, {})
			vim.keymap.set("n", "<leader>s", builtin.marks, {})
			vim.keymap.set("n", "<leader>j", builtin.jumplist, {})
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build =
		"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
}
