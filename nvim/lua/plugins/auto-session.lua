-- auto-session 2.x renamed every option: the old `auto_session_*` names are
-- detected and mostly back-translated, but it sets has_old_config and nags
-- about them. These are the current names.
return {
	{

		"rmagatti/auto-session",
		lazy = false,
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
		config = function()
			require('auto-session').setup({
				enabled = true,
				log_level = "error",
				root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_save = true,
				auto_restore = true,
				auto_restore_last_session = false,
				git_use_branch_name = true,
				lazy_support = true,
			})

			vim.o.sessionoptions =
			"blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end



	},
}
