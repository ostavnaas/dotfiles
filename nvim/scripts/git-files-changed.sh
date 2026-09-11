#!/usr/bin/env bash
# Cred ivan-cukic https://github.com/nvim-telescope/telescope.nvim/issues/758
set -euo pipefail

if [[ "${1:-}" != "list" && "${1:-}" != "diff" ]] ||
    [[ "${1:-}" == "diff" && $# -ne 2 ]]; then
    echo "Usage: $0 list | diff <file>" >&2
    exit 1
fi

BRANCH="${PROJECT_MAIN_BRANCH:-}"
if [[ -z "$BRANCH" ]]; then
    # Use the remote's recorded default without requiring network access.
    BRANCH=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null || true)
    if [[ -z "$BRANCH" ]]; then
        for candidate in refs/remotes/origin/main refs/remotes/origin/master refs/heads/main refs/heads/master; do
            if git rev-parse --verify --quiet "$candidate^{commit}" >/dev/null; then
                BRANCH="$candidate"
                break
            fi
        done
    fi
fi

if [[ -z "$BRANCH" ]]; then
    echo "Cannot detect the default branch; set PROJECT_MAIN_BRANCH." >&2
    exit 1
fi

BASE=$(git merge-base "$BRANCH" HEAD)
# Compare the working tree with the fork point, including local tracked edits.
if [[ "$1" == "list" ]]; then
    git diff --name-only --diff-filter=ACMR --relative "$BASE" --
elif [[ "$1" == "diff" ]]; then
    git diff --diff-filter=ACMR --relative "$BASE" -- "$2"
fi
