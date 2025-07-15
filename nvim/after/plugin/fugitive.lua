vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local bufnr = vim.api.nvim_get_current_buf()

local opts = {buffer = bufnr, remap = false}

vim.keymap.set("n", "<leader>p", function()
	vim.cmd.Git('pull')
end, opts)

vim.keymap.set("n", "<leader>P", function()
	vim.cmd.Git('push')
end, opts)

vim.keymap.set("n", "<leader>S", function()
	vim.cmd.Git('stash')
end, opts)


