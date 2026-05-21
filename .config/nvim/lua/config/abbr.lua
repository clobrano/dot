vim.cmd([[
iabbrev <expr> hdate strftime("%A %d %B")
iabbrev <expr> dday strftime("%A")
iabbrev <expr> ddy toupper(strftime("(%a)"))
]])
