#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# shellcheck disable=SC2016

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
git config --global alias.wa '!f() { if [ -z "$1" ]; then echo "Usage: git wa <branch-name> [<base-branch>]"; return 1; fi; local new_branch_name="$1"; local base_branch="${2:-main}"; local current_repo_name=$(basename "$(pwd)"); local worktree_path="../${current_repo_name}-${new_branch_name}"; git worktree add -b "${new_branch_name}" "${worktree_path}" "${base_branch}"; }; f'
