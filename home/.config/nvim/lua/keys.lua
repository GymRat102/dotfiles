-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })
-- prevent visual y-p replace your register
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
