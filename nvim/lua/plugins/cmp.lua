return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"windwp/nvim-autopairs",
		},

		config = function()
			-- autopairs needs its own setup for the pairing itself; the cmp
			-- integration below only handles parens added by a completion.
			require("nvim-autopairs").setup({})

			-- nvim-cmp setup
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			cmp.setup({
				-- No snippet engine on purpose: LuaSnip is not installed, and the
				-- expand/jump callbacks that referenced it errored on <S-Tab>.
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
					["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace, -- Replace
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
				},
			})
		end,
	},
}
