vim.cmd([[
" ISO date and week number
iabbrev <expr> ddw strftime("%F week %V")
" ISO date and day of the week
iabbrev <expr> ddd strftime("%F %a")
" TIME for weekly notes [HH:MM] so that it is more visible"
iabbrev <expr> ttime strftime("\[%H:%M\]")
iabbrev <expr> ddy strftime("%a\|")

iabbrev <expr> ddate strftime("%F")
iabbrev <expr> hdate strftime("%A %d %B")
iabbrev <expr> dday strftime("%A")
iabbrev <expr> ddyp strftime("(%a)")
]])
