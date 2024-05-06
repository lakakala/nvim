require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- A list of servers to automatically install if they're not already installed
	ensure_installed = { "pylsp", "lua_ls", "rust_analyzer" },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require("luasnip")
local cmp = require("cmp")

lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {},
	},
	capabilities = capabilities,
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

require("lspsaga").setup({})

require("symbols-outline").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
