return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -G Ninja -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	config = function()
		local builtin = require("telescope.builtin")
		local telescope = require("telescope")
		telescope.load_extension("fzf")

		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = { height = 0.95 },
			},
			pickers = {
				find_files = {
					follow = true,
					path_display = { "smart" },
				},
				lsp_references = {
					fname_width = 0.5,
					path_display = { "truncate" },
				},
			},
		})
	end,
}
