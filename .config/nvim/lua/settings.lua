vim.wo.wrap = false
vim.o.fileencoding = "utf-8"
vim.o.cmdheight = 2
vim.o.mouse = "a"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.conceallevel = 0
vim.cmd('set sw=4')
vim.bo.smartindent = true
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true
vim.o.showtabline = 2
vim.o.backup = false
vim.o.writebackup = false
vim.wo.signcolumn = "yes"
vim.o.updatetime = 300
vim.o.timeoutlen = 1000
vim.opt.clipboard = "unnamedplus"

-- Open a file from its last left off position
 vim.cmd [[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
