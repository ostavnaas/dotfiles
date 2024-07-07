return {
	{
		"jacoborus/tender.vim",
		init = function()
			vim.cmd.set("termguicolors")
			vim.cmd.colorscheme("tender")
			vim.api.nvim_set_hl(0,
				'normalfloat',
				{
					bg = '#335261',
				})
		end,
	},

	{ "ntpeters/vim-better-whitespace" },
}
