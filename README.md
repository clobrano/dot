# dot

This is my dotfiles repository.

## Installation

### dependencies

```sh
dnf install git stow [gh]
```

## Clone the repo

```sh
git clone https://github.com/clobrano/dot .dot
or
gh repo clone clobrano/dot .dot
```

## Linking

```sh
cd ~/.dot
stow .
# do not override bashrc, just source my customization
echo "source ~/.dot/mybashrc >> ~/.bashr"
```

(Thanks to https://www.youtube.com/watch?v=y6XCebnB9gs for the introduction to Stow)
