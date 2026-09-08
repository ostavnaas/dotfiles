-- nvim-treesitter's `main` branch (what lazy-lock pins) dropped the module
-- system: setup() takes only `install_dir`, and `ensure_installed`, `highlight`
-- and `indent` are gone. Passing them silently does nothing -- which is why only
-- the markdown parsers were ever installed and python fell back to regex syntax.
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},

	config = function()
		local ts = require("nvim-treesitter")
		ts.setup()

		-- Parsers are installed explicitly now. install() is async and a no-op for
		-- anything already present, so only a first run pays for it.
		local wanted = { "python", "lua", "markdown", "markdown_inline" }
		local installed = ts.get_installed()
		local missing = vim.tbl_filter(function(parser)
			return not vim.tbl_contains(installed, parser)
		end, wanted)
		if #missing > 0 then
			ts.install(missing)
		end

		-- Starting the highlighter and wiring indentation is the caller's job on
		-- this branch. Filetypes, not parser names -- markdown_inline is injected
		-- into markdown rather than being a filetype of its own.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
			pattern = { "python", "lua", "markdown" },
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Syntax aware text-objects, which also need their own keymaps now.
		local textobjects = require("nvim-treesitter-textobjects")
		textobjects.setup({
			select = { lookahead = true },
		})

		local select = require("nvim-treesitter-textobjects.select")
		local objects = {
			af = "@function.outer",
			["if"] = "@function.inner",
			ac = "@class.outer",
			ic = "@class.inner",
		}
		for lhs, capture in pairs(objects) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				select.select_textobject(capture, "textobjects")
			end, { desc = "Select " .. capture })
		end
	end
}
