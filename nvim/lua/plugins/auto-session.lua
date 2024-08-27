return {
	{

		"rmagatti/auto-session",
		lazy = false,
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
		config = function()
			require('auto-session').setup({
				log_level = "error",
				auto_session_enable_last_session = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = nil,
				auto_restore_enabled = nil,
				auto_session_suppress_dirs = nil,
				auto_session_use_git_branch = true,
				auto_restore_lazy_delay_enabled = true,
				-- the configs below are lua only
				bypass_session_save_file_types = nil,
			})

			vim.o.sessionoptions =
			"blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end




	},
}
