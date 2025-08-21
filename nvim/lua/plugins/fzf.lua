return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
		vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", {})
		vim.keymap.set("n", "<leader>fh", ":FzfLua helptags<CR>", {})
		vim.keymap.set("n", "<leader>fg", ":FzfLua grep<CR>", {})
		vim.keymap.set("n", "<leader>fd", ":FzfLua diagnostics_workspace<CR>", {})
		vim.keymap.set("n", "<leader>fG", ":FzfLua lsp_workspace_symbols<CR>", {})
    end,
}
