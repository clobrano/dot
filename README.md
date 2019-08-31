# dot
Dotfiles repo

## Install and configure

Clone the bare repository. `.dot` directory will be the equivalent of the usual `.git` one, while the repository will be the whole `$HOME`.

    $ git clone --bare git@github.com:clobrano/dot.git $HOME/.dot
    
Do not show untracked files

    $ /usr/bin/git --git-dir=$HOME/.dot/ --work-tree=$HOME config --local status.showUntrackedFiles no
    
Temporary alias "dotfiles" to run `git` commands with the proper configuration

    $ alias dotfiles='/usr/bin/git --git-dir=$HOME/.dot/ --work-tree=$HOME'

Apply all changes

    $ dotfiles reset --hard master

Refresh bash

    $ source .bashrc
