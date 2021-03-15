local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use "neovim/nvim-lspconfig"
	use "hrsh7th/nvim-compe"
	use 'hrsh7th/vim-vsnip'
	use 'windwp/nvim-autopairs'
	use "kyazdani42/nvim-tree.lua"
	use 'kyazdani42/nvim-web-devicons'
--	use { 'nvim-treesitter/nvim-treesitter', run=':TSUpdate' }
	use 'nvim-telescope/telescope.nvim'
	use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons' }
end)
