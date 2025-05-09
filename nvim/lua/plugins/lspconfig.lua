-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
			vim.cmd('normal! zz')
		end
		, opts)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
			vim.cmd('normal! zz')
		end, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", function()
			vim.lsp.buf.type_definition()
			vim.cmd('normal! zz')
		end
		, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		local reops = { buffer = ev.buf, jump_type = "vsplit" }
		vim.keymap.set("n", "gr", builtin.lsp_references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = false })
		end, opts)
	end,
})
local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

local organize_import = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			for _, command in ipairs({
				--"ruff.applyOrganizeImports",
				"ruff.applyFormat",
				"ruff.applyAutofix",
			}) do
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				client.request_sync("workspace/executeCommand", {
					command = command,
					arguments = {
						{ uri = vim.uri_from_bufnr(0), version = 045 },
					},
				})
			end
		end
	)
end
dump = function(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

return {

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"nvim-telescope/telescope.nvim",
			-- "astral-sh/ruff-lsp",
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			-- Use telescope for lsp refrerences
			local transform_mod = require("telescope.builtin")
			local handlers = {
				["textDocument/references"] = transform_mod,
			}

			--vim.lsp.set_log_level("debug")

			--- lsp_cero ---
			--local lsp_zero = require("lsp-zero")
			----lsp_zero.extend_lspconfig()

			--lsp_zero.on_attach(function(client, bufnr)
			--	lsp_zero.default_keymaps({ buffer = bufnr })
			--end)

			---- don't add this function in the `on_attach` callback.
			---- `format_on_save` should run only once, before the language servers are active.
			--lsp_zero.format_on_save({
			--	format_opts = {
			--		async = false,
			--		timeout_ms = 10000,
			--	},
			--	servers = {
			--		["ruff_lsp"] = { "python" },
			--	},
			--})
			--- lsp_cero end ---

			-- Ruff command to organize imports on save
			---@param name string
			---@return lsp.Client
			local function lsp_client(name)
				return assert(
					vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf(), name = name })
					[1],
					("No %s client found for the current buffer"):format(name)
				)
			end

			--- astral-sh/ruff-lsp
			local on_attach = function(client, bufnr)
				-- Disable hover in favor of Pyright
				if client.name == "ruff" then
					client.server_capabilities.hoverProvider = false
				end

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							--async_formatting(bufnr)
							organize_import(bufnr)
						end,
					})
				end
			end

			-- Setup language servers.
			local lspconfig = require("lspconfig")
			-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
			local languages = {
				pyright = {
					settings = {
						pyright = {
							disableLanguageServices = false,
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								autoImportCompletions = true,
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								typeCheckingMode = "strict",
							},
						},
					},
				},
				gopls = {},
				ruff = {
					settings = { organizeImports = true, fixAll = true },
				},
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
				typos_lsp = {},
			}
			local capabilities = require("cmp_nvim_lsp").default_capabilities()


			for lsp, config in pairs(languages) do
				--print(string.format("%s config: %s", lsp, dump(config)))
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = config.settings,
					handlers = handlers,
					commands = config.commands or {},
				})
			end

			-- hackz to organize imports on save, until ruff_lsp supports it
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.lua",
				callback = function()
					vim.lsp.buf.format()
				end,
			})
			-- Configure diagnostics
			-- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
			vim.diagnostic.config({
				-- virtual_text = true,
				virtual_lines = {
					current_line = true,
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		desc = "https://mason-registry.dev/registry/list",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({

				ensure_installed = {
					"gopls",
					-- "ruff_lsp",
					"lua_ls",
					"typos_lsp",
				},
			})
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		config = function()
			local lsp_zero = require("lsp-zero")
			--lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			-- don't add this function in the `on_attach` callback.
			-- `format_on_save` should run only once, before the language servers are active.
			lsp_zero.format_on_save({
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				-- servers = {
				-- 	["ruff_lsp"] = { "python" },
				-- },
			})
		end,
	},
}

-- end astral-sh/ruff-lsp
-- end astral-sh/ruff-lsp
