#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
git config --global alias.cfiles "!git diff --name-only \$(git merge-base HEAD \"\${MAIN_BRANCH:-main}\")"
git config --global alias.stat "!git diff --stat \$(git merge-base HEAD \"\${MAIN_BRANCH:-main}\")"
git config --global alias.reviewall "!nvim -c \"DiffviewOpen \${MAIN_BRANCH:-main}\""
git config --global alias.review "!nvim -p +\"tabdo Gvdiff \${MAIN_BRANCH:-main}\" +\"let g:gitgutter_diff_base = '\${MAIN_BRANCH:-main}'\""
git config --global alias.sync "!git pull upstream \${MAIN_BRANCH:-main} && git push origin \${MAIN_BRANCH:-main}"
git config --global alias.syncone "!git pull upstream $(g branch | awk '/*/{print $2}') && git push origin $(g branch | awk '/*/{print $2}')"
