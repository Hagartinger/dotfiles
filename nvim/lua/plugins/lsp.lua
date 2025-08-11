local servers = {
	clangd = {
		cmd = {
			"clangd",
			"--header-insertion-decorators",
			"--all-scopes-completion",
			"--background-index",
			"--completion-style=detailed",
			"--clang-tidy",
			"--pch-storage=memory",
		},
		root_dir = function()
			return vim.fn.getcwd()
		end,
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	},
    slang = { settings = {}},
    cmake = {},
}

local setup_keymaps_on_lsp_attach = function()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("hagartinger-lsp-attach", { clear = true }),
		callback = function(event)
			local telescope_builtin = require("telescope.builtin")
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Jump to the definition of the word under your cursor.
			--  This is where a variable was first declared, or where a function is defined, etc.
			--  To jump back, press <C-t>.
			map("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			map("gt", telescope_builtin.lsp_type_definitions, "[G]oto [T]ype")
			-- Find rederences for the word
			map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")

			local switch_virtual_text = function()
				local config = vim.diagnostic.config() or {}
				if config.virtual_text then
					vim.diagnostic.config({ virtual_text = false })
				else
					vim.diagnostic.config({ virtual_text = true })
				end
			end
			map("<leader>sv", switch_virtual_text, "[S]witch [V]irtual lines")
			map("<leader>sd", vim.diagnostic.open_float, "[S]how [D]iagnostics")
		end,
	})
end

vim.diagnostic.config({
	signs = false,
	virtual_text = false,
	underline = true,
	severity_sort = true,
})

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
                    vim.list_extend(opts.ensure_installed, vim.tbl_keys(servers or {}))
				end,
			},
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			setup_keymaps_on_lsp_attach()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(servername)
						local server = servers[servername] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						lspconfig[servername].setup(server)
					end,
				},
			})
		end,
	},
}
