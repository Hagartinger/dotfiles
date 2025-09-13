local servers = {
	clangd = {
		cmd = {
			"clangd",
			"--header-insertion-decorators",
			"--all-scopes-completion",
			"--background-index",
			"--completion-style=detailed",
			"--clang-tidy",
            "--limit-references=0",
            "--limit-results=0",
			"--pch-storage=memory",
		},
		root_dir = function(buffnr, on_dir)
            on_dir(vim.fn.getcwd())
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
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Jump to the definition of the word under your cursor.
			--  This is where a variable was first declared, or where a function is defined, etc.
			--  To jump back, press <C-t>.
			map("<leader>gd", ":FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")
			map("<leader>gD", ":FzfLua lsp_declarations<CR>", "[G]oto [D]eclaration")

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			map("<leader>gt",  ":FzfLua lsp_typedefs<CR>", "[G]oto [T]ype")
			-- Find rederences for the word
			map("<leader>gr",   ":FzfLua lsp_references<CR>", "[G]oto [R]eferences")
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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			require("mason").setup()
			require("mason-lspconfig").setup()

            for server_name, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
                vim.lsp.config[server_name] = config
                vim.lsp.enable(server_name)
            end
		end,
	},
}
