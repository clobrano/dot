# dot

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

Install dependencies:
```sh
dnf install git stow
```

Clone and link:
```sh
git clone https://github.com/clobrano/dot ~/.dot
cd ~/.dot
stow .
```

Stow mirrors the repo structure into `$HOME` as symlinks. For example,
`.dot/.config/nvim/` becomes `~/.config/nvim/` → `~/.dot/.config/nvim/`.

### Bashrc

Don't replace `~/.bashrc` — just append a source line:
```sh
echo "source ~/.dot/mybashrc" >> ~/.bashrc
```

## Adding a new file or folder

1. Move the file into `.dot`, keeping the same relative path it has under `$HOME`:
   ```sh
   # e.g. to track ~/.config/foo/bar.conf
   mkdir -p ~/.dot/.config/foo
   mv ~/.config/foo/bar.conf ~/.dot/.config/foo/bar.conf
   ```
2. Re-run stow to create the symlink:
   ```sh
   cd ~/.dot && stow .
   ```
3. Commit:
   ```sh
   git add .config/foo/bar.conf && git commit -m "feat: track foo config"
   ```

## Updating symlinks

If the repo already has a file but the symlink is missing (e.g. after a fresh clone), just run:
```sh
cd ~/.dot && stow .
```

To remove all symlinks without deleting the repo files:
```sh
cd ~/.dot && stow -D .
```
