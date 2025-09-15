return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function(_, opts)
		vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", {})
		vim.keymap.set("n", "<leader>fh", ":FzfLua helptags<CR>", {})
		vim.keymap.set("n", "<leader>fg", ":FzfLua grep<CR>", {})
		vim.keymap.set("n", "<leader>fd", ":FzfLua diagnostics_workspace<CR>", {})
		vim.keymap.set("n", "<leader>fG", ":FzfLua lsp_workspace_symbols<CR>", {})

		opts.files = {
			rg_opts = [[--color=never --hidden --files -g "!.git" -g "!.cache"]],
			fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude .cache]],
		}

		return opts
	end,
}
