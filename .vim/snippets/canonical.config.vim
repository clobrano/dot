function! LpBugTitle(buglink)
if !has('python')
    echo 'LpBugTitle requires python'
    finish
endif

python << EOF
import os
import vim

from launchpadlib.launchpad import Launchpad

buglink = vim.eval('a:buglink')
bugno = buglink.split('/')[-1]
vim.command('let bugno = "%s"' % bugno)

cachedir = os.path.join(os.path.expanduser('~'), '.launchpadlib', 'cache')
launchpad = Launchpad.login_anonymously('getting bug data', 'production', cachedir, version='devel')
vim.command('let title = "%s"' % launchpad.bugs[bugno].title.replace('"', "'"))

EOF

echo title
let curline = line('.')
call setline(curline, '+bug [' . bugno . '](' . a:buglink . ') [' . title . '](bug' . bugno. ')')
endfunction
nnoremap <leader>cb vE"ay<esc>:call LpBugTitle('<C-r>"')<cr>

" use gnome-screenshoot to take a pic
cabbr shot !gnome-screenshot -capf ~/Pictures/tmp.png
command! -nargs=1 Shot  :!gnome-screenshot -capf <f-args>
