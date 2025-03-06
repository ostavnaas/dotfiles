#!/usr/bin/env bash
# Cred ivan-cukic https://github.com/nvim-telescope/telescope.nvim/issues/758
BRANCH="$PROJECT_MAIN_BRANCH"

if [[ -z "$BRANCH" ]]; then
    BRANCH="origin/master"
fi

if [[ "$1" == "list" ]]; then
    git diff --name-only --diff-filter=ACMR --relative $BRANCH
elif [[ "$1" == "diff" ]]; then
    git diff --diff-filter=ACMR --relative $BRANCH "$2"
fi

