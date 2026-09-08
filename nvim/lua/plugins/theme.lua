return {
	{
		"jacoborus/tender.vim",
		init = function()
			vim.cmd.set("termguicolors")

			-- Re-applied on every colorscheme load: set once after
			-- vim.cmd.colorscheme() they are lost the next time it runs.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("TenderOverrides", { clear = true }),
				pattern = "tender",
				callback = function()
					vim.api.nvim_set_hl(0,
						'normalfloat',
						{
							bg = '#335261',
						})

					-- tender predates treesitter, so it only styles the vim-syntax
					-- group markdownCode. With the markdown_inline parser active
					-- that group never applies and `code` falls back to
					-- @markup.raw -> Comment -> #666666, which is unreadable on a
					-- dark terminal. Point the treesitter captures at the colour
					-- tender already picked for markdownCode.
					vim.api.nvim_set_hl(0,
						'@markup.raw',
						{
							fg = '#d3b987',
						})
					vim.api.nvim_set_hl(0,
						'@markup.raw.markdown_inline',
						{
							fg = '#d3b987',
						})
				end,
			})

			vim.cmd.colorscheme("tender")
		end,
	},

	{ "ntpeters/vim-better-whitespace" },
}
