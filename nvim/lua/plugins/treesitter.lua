return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" }, -- Syntax aware text-objects
		-- {
		-- 	"nvim-treesitter/nvim-treesitter-context", -- Show code context
		-- 	opts = { enable = true, mode = "topline", line_numbers = true }
		-- }
	},
	--
	config = function()
		local configs = require("nvim-treesitter")

		configs.setup({
			ensure_installed = { "python", "lua", "markdown" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end


}


--
--If you actually want to remove the plugin entirely, Neovim 0.10+ has built-in treesitter, but with caveats:

-- No plugin entry. Add to your config instead:
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "python", "lua", "markdown" },
--     callback = function(args)
--         pcall(vim.treesitter.start, args.buf)
--     end,
-- })
--
-- Limitations of going plugin-free:
-- - Highlight: works via vim.treesitter.start() as above
-- - Indent: no built-in equivalent — falls back to filetype indentation
-- - Parser install: lua and markdown are bundled; python requires manual parser management (no :TSInstall)
