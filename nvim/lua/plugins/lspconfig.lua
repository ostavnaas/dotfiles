return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.enable({ 'pyright', "ruff", "lua_ls" ,"ty" })

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				--
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = args.buf }
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "gD", function()
					vim.lsp.buf.declaration()
					vim.cmd('normal! zz')
				end
				)
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
					vim.cmd('normal! zz')
				end)
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "K", vim.lsp.buf.hover)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
					opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end)
				vim.keymap.set("n", "<leader>D", function()
					vim.lsp.buf.type_definition()
					vim.cmd('normal! zz')
				end
				)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "gr", vim.lsp.buf.references)
				-- local reops = { buffer = args.buf, jump_type = "vsplit" }
				vim.keymap.set("n", "gr", builtin.lsp_references)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = false })
				end)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)


				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client:supports_method("textDocument/formatting") then
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
				end


				if client:supports_method('textDocument/completion') then
					vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
				end
				if client.name == "ruff" then
					client.server_capabilities.hoverProvider = false
				end


				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.lua", "*.py" },
					callback = function()
						vim.lsp.buf.format()
					end,
				})
				-- 			-- Configure diagnostics
				-- 			-- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
				vim.diagnostic.config({
					-- virtual_text = true,
					virtual_lines = {
						current_line = true,
					},
				})
			end
		})
	end
}
