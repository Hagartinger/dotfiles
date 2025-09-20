return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
	},
	config = function()
		local dap = require("dap")

		--dap.set_log_level('TRACE')

		dap.adapters.nativelldb = {
			type = "executable",
			command = vim.fn.exepath("lldb-dap"),
			options = {
				env = {
					"LLDB_USE_NATIVE_PDB_READER=1",
				},
			},
		}

		dap.configurations.cpp = {
			{
				name = "nativeLLDB",
				type = "nativelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
		}

		vim.keymap.set("n", "<Leader>ds", function()
			require("dap").continue()
		end)
		vim.keymap.set("n", "<Leader>j", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<Leader>k", function()
			require("dap").step_out()
		end)
		vim.keymap.set("n", "<Leader>l", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>dr", function()
			require("dap").repl.open()
		end)
	end,
}
