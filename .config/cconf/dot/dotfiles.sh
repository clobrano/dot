# Easy way to automatically source any alias file,
# as long as it is in the proper directory
export DOTFILES=$HOME/.config/cconf

if [ -d  "$DOTFILES/aliases" ]; then
    for i in $(ls "$DOTFILES/aliases"); do
        source "$DOTFILES/aliases/$i"
    done
fi
