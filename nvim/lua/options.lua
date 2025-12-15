-- Enable line number with relative numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable mouse
vim.opt.mouse = ""

-- Save undo history
vim.opt.undofile = true

-- Ignore case in searching
vim.opt.ignorecase = true

-- Keep singcolumn on
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Disable timeout for mapped sequence
vim.opt.timeout = false

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Highlights the line cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 8

-- More space in command line for displaying messages
vim.opt.cmdheight = 2

vim.opt.termguicolors = true

-- Display tab as 4 spaces
vim.opt.tabstop = 4
-- number of spaces to use for (auto)indent step
vim.opt.shiftwidth = 4
-- Use spaces instead of tabs in insert mode
vim.opt.expandtab = true

vim.opt.conceallevel = 1
