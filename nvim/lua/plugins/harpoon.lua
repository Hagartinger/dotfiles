return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-m>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- Reconfigure to use fzf-lua instead of Telescope
		vim.keymap.set("n", "<leader>fm", function()
			local file_paths = {}
			for _, item in ipairs(harpoon:list().items) do
				table.insert(file_paths, item.value)
			end
			require("fzf-lua").fzf_exec(file_paths, {
				actions = {
					-- Use fzf-lua builtin actions or your own handler
					["default"] = require("fzf-lua").actions.file_edit,
				},
			})
		end, { desc = "[F]ind [M]arks" })
	end,
}
