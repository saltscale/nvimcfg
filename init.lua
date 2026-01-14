vim.g.mapleader = " "
vim.o.number = true             -- Enable line numbers
vim.o.relativenumber = true     -- Enable relative line numbers
vim.o.tabstop = 4               -- Number of spaces a tab represents
vim.o.shiftwidth = 4            -- Number of spaces for each indentation
vim.o.expandtab = true          -- Convert tabs to spaces
vim.o.smartindent = true        -- Automatically indent new lines
vim.o.wrap = false              -- Disable line wrapping
vim.o.cursorline = true         -- Highlight the current line

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end
vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = paste,
		['*'] = paste,
	},
}
-- To ALWAYS use the clipboard for ALL operations
-- (instead of interacting with the "+" and/or "*" registers explicitly):
vim.opt.clipboard = "unnamedplus"

-- stop deselection after formatting text
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })

-- lazy bootstrap
require "lazy-bootstrap"

-- set color schme
vim.cmd("colorscheme dark_flat")

-- make background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none" })

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = "*.ipynb",
--   callback = function()
--     vim.bo.filetype = "python"
--   end,
-- })

-- vim.cmd("filetype plugin indent on")
