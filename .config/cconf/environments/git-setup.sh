#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

tools=( git-delta )
for tool in "${tools[@]}"; do
    echo "installing $tool..."
    sudo dnf install "$tool" -y
done

echo "Configuring aliases"
git config --global alias.cfiles "!git diff --name-only \$(git merge-base HEAD \"\${MAIN_BRANCH:-main}\")"
git config --global alias.stat "!git diff --stat \$(git merge-base HEAD \"\${MAIN_BRANCH:-main}\")"
git config --global alias.reviewall "!nvim -c \"DiffviewOpen \${MAIN_BRANCH:-main}\""
git config --global alias.review "!nvim -p +\"tabdo Gvdiff \${MAIN_BRANCH:-main}\" +\"let g:gitgutter_diff_base = '\${MAIN_BRANCH:-main}'\""
git config --global alias.sync "!git pull upstream \${MAIN_BRANCH:-main} && git push origin \${MAIN_BRANCH:-main}"
git config --global alias.syncthis "!git pull upstream $(git branch | awk '/*/{print $2}') && git push origin $(git branch | awk '/*/{print $2}')"
git config --global alias.sw "!git switch"
