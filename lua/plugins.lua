local M = {}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	local plugins = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"nvimdev/lspsaga.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"stevearc/conform.nvim",
		{
			"nvimdev/dashboard-nvim",
			event = "VimEnter",
			config = function()
				require("dashboard").setup({
					-- config
				})
			end,
			dependencies = { { "nvim-tree/nvim-web-devicons" } },
		},
		{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
		{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
		"simrat39/symbols-outline.nvim",
	}
	local opts = {}
	require("lazy").setup(plugins, opts)

	require("plugins-config.lsp")
	require("plugins-config.appearance")
end

return M
