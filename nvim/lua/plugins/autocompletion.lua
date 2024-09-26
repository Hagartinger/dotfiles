return {
	-- A completion engine plugin
	"hrsh7th/nvim-cmp",
	-- Load before entering Insert mode
--	event = "InsertEnter",
	dependencies = {
	      -- Adds other completion capabilities.
	      --  nvim-cmp does not ship with all sources by default. They are split
	      --  into multiple repos for maintenance purposes.
	      'hrsh7th/cmp-path',   -- path completions
	      'hrsh7th/cmp-buffer', -- buffer completions 
	      'hrsh7th/cmp-nvim-lsp' -- LSP completions
      	},
	-- setup function
	config = function()
		local cmp = require 'cmp'
		cmp.setup({
			mapping = {
				['<Tab>'] = cmp.mapping.select_next_item(),
				['<S-Tab>'] = cmp.mapping.select_prev_item(),
				['<CR>'] = cmp.mapping.confirm(),
				['<C-Space>'] = cmp.mapping.complete{},
				['<C-j>'] = cmp.mapping.scroll_docs(-4),
				['<C-k>'] = cmp.mapping.scroll_docs(4),
			},
			sources = {
			    { name = "nvim_lsp" },
			    { name = "buffer" },
			    { name = "path" },
		  	},
			window = {
				documentation = cmp.config.window.bordered()
			}
		})
	end
}
