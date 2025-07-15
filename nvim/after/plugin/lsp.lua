local lsp = require('lsp-zero').preset({})

lsp.preset("recommended")

lsp.ensure_installed({
'tsserver',
'eslint',
'rust_analyzer',
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')

cmp.setup({
	mapping = {
	    ['CR'] = cmp.mapping.confirm({select = true}),
	}
})


