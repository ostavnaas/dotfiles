require("config.keymaps")
require("config.lazy")

vim.opt.number = true
vim.opt.mouse = ""

-- Spell only where prose is. Set globally it flags every identifier in code.
vim.opt.spelllang = "en_us"
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("SpellProse", { clear = true }),
	pattern = { "markdown", "gitcommit", "text" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
