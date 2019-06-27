command! CLIntClean /^# GENERATED_CODE: start | v /^# GENERATED_CODE: end
command! CLInt r !~/.dotfiles/vim/vim/snippets/CLInt/clint.sh -s %
" Redirect to syslog
iabbr redsys exec 1> >(logger -s -t $(basename $0)) 2>&1
