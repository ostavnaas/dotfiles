return {
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.9.2",
	build = ":TSUpdate",
	-- dependencies = {
	-- 	{ "nvim-treesitter/nvim-treesitter-textobjects" }, -- Syntax aware text-objects
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context", -- Show code context
	-- 	opts = { enable = true, mode = "topline", line_numbers = true }
	-- }
	-- },
	--
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "python", "lua", "markdown"},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end


}
