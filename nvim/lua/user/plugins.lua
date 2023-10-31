local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'-- Have packer manage itself
  use 'neovim/nvim-lspconfig'
  use {'neoclide/coc.nvim', run  = {'yarn install --frozen-lockfile'}}
-- use 'hrsh7th/nvim-cmp'
-- use 'hrsh7th/cmp-nvim-lsp'
-- use 'hrsh7th/cmp-nvim-lsp-signature-help'
-- use 'hrsh7th/cmp-nvim-lsp-document-symbol'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'nvim-lua/plenary.nvim'
--  use {'junegunn/fzf', run  = 'fzf#install' }
--  use 'junegunn/fzf.vim'
  use 'jacoborus/tender.vim'
  use 'feline-nvim/feline.nvim'
  use {
	    'nvim-telescope/telescope.nvim', tag = '0.1.1',
	    requires = { {'nvim-lua/plenary.nvim'} }
	    }
  use "lukas-reineke/indent-blankline.nvim"
  use 'lewis6991/gitsigns.nvim'
  use 'rmagatti/auto-session'



	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)