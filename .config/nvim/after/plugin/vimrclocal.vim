if filereadable(expand('vimrc.local'))
    exe 'source vimrc.local'
endif

command! Svimrc :!cat vimrc.local
command! Evimrc :e vimrc.local
command! Lvimrc :exe 'source vimrc.local'

iabbr evimrc Evimrc
iabbr svimrc Svimrc
iabbr lvimrc Lvimrc
