return {
	"neovim/nvim-lspconfig",
	config = function()
		-- The other half of installing cmp-nvim-lsp: without this the servers are
		-- never told what nvim-cmp can do (snippets, resolve support), so
		-- completion comes back poorer than it needs to be.
		vim.lsp.config('*', {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})

		vim.lsp.enable({ 'pyright', "ruff", "lua_ls", "ty", "gopls" })

		-- Global settings, so they belong here rather than in LspAttach: that
		-- fires once per client per buffer, and pyright/ruff/ty all attach to the
		-- same .py file.
		-- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
		vim.diagnostic.config({
			-- virtual_text = true,
			virtual_lines = {
				current_line = true,
			},
		})

		-- One group for the format-on-save hooks, cleared per buffer below, so
		-- three attaches cannot install three handlers on one buffer.
		local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				--
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings -- `opts` has to be passed to every one of
				-- them, or they are set globally and stay live in buffers with no
				-- LSP attached (K shadowing keywordprg everywhere, say).
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = args.buf }
				local builtin = require("telescope.builtin")

				-- Jump, then recentre.
				local function centred(fn)
					return function()
						fn()
						vim.cmd('normal! zz')
					end
				end

				vim.keymap.set("n", "gD", centred(vim.lsp.buf.declaration), opts)
				vim.keymap.set("n", "gd", centred(vim.lsp.buf.definition), opts)
				vim.keymap.set("n", "<leader>D", centred(vim.lsp.buf.type_definition), opts)
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", builtin.lsp_references, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = false })
				end, opts)
				-- diagnostic.goto_prev/goto_next are deprecated since 0.11.
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client.name == "ruff" then
					-- Let pyright own hover; ruff's is noise on top of it.
					client.server_capabilities.hoverProvider = false
				end

				-- BufWritePre, not BufWritePost: formatting after the write leaves
				-- the file on disk unformatted and the buffer modified.
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = format_group, buffer = args.buf })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = format_group,
						buffer = args.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = args.buf, async = false })
						end,
					})
				end
			end
		})
	end
}
