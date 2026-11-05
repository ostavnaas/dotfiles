# Profile startup: uncomment, then `zprof` at the end of the file
#zmodload zsh/zprof

typeset -U path fpath   # keep PATH/fpath free of duplicates
path+=($HOME/.local/bin $HOME/go/bin)

# ---------------------------------------------------------------------------
# Completions (must be set up before oh-my-zsh runs compinit)
# ---------------------------------------------------------------------------
# Cache generated completion scripts; regenerated only when the binary changes
ensure_completion() {
  local cmd=$1; shift
  local dir=$HOME/.zsh-completions
  local file=$dir/_$cmd

  (( $+commands[$cmd] )) || return 0
  [[ -s $file && $file -nt ${commands[$cmd]} ]] && return 0

  mkdir -p $dir
  if ! "$cmd" "$@" > $file.tmp 2>/dev/null; then
    rm -f $file.tmp; return 1
  fi
  mv $file.tmp $file
}
ensure_completion kubectl completion zsh
ensure_completion stern --completion=zsh

fpath+=($HOME/.zsh-completions)

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"   # skip compaudit on every start
plugins=(git docker-compose)
source $ZSH/oh-my-zsh.sh

# Remove user@host from agnoster prompt
prompt_context() {}

[[ -f ~/.zsh_local ]] && source ~/.zsh_local

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export NPM_CONFIG_PREFIX=$HOME/.local   # npm globals -> ~/.local/{bin,lib}

HISTSIZE=10000000
SAVEHIST=10000000
export EDITOR=nvim

export PIPENV_VENV_IN_PROJECT=1
export PYTHONBREAKPOINT="pudb.set_trace"   # https://documen.tician.de/pudb/starting.html
export CHEAT_CONFIG_PATH="$HOME/github/ostavnaas/dotfiles/cheat/conf.yml"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export AWS_SDK_LOAD_CONFIG=1               # needed for kops with aws sso login
export GPG_TTY=$TTY                        # for eyaml
: ${SSH_AUTH_SOCK:=$XDG_RUNTIME_DIR/ssh-agent.socket}
export SSH_AUTH_SOCK

# https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
(( $+commands[pyenv] )) && eval "$(pyenv init - --no-rehash zsh)"

typeset -U path   # re-apply: sourced scripts above may re-tie PATH without -U

# https://github.com/cheat/cheat
[[ -e ~/github/ostavnaas/dotfiles/cheat/cheat.zsh ]] && source ~/github/ostavnaas/dotfiles/cheat/cheat.zsh

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias gcam='git commit --amend --no-edit'
alias ip3='ipython3'
alias less='less -S'
alias df='df --exclude-type=squashfs'
alias vim='nvim'
alias k=kubectl
alias kx=kubectx
alias dotfiles='cd ~/github/ostavnaas/dotfiles'
alias grafana='docker compose --file ~/github/ostavnaas/dotfiles/docker/grafana/docker-compose.yml up'

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------
# *Nix safe password
pwgen() {
  /usr/bin/pwgen -r "\"\'\$\,\[\]\*\?\{\}\~\#\%\\\<\>\|\^\;\`\/" -y $1
}

up()   { docker compose up }
down() { docker compose down }

# Override oh-my-zsh git plugin: prefer main, then production, else master
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in main production; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo master
}

# gco with no args: pick a branch with fzf (most recent first); with args: plain git checkout
unalias gco 2>/dev/null   # replaces the oh-my-zsh git plugin alias
gco() {
  if (( $# )); then
    git checkout "$@"
    return
  fi

  local branch
  branch=$(
    git for-each-ref --sort=-committerdate \
      --format='%(refname:short)' refs/heads refs/remotes |
    grep -v -e '/HEAD$' -e '^origin$' |
    fzf --height 40% --reverse \
        --preview 'git log --oneline --graph --color=always -20 {}'
  ) || return

  # origin/foo -> check out (and track) local foo
  git checkout "${branch#origin/}"
}
compdef _git gco=git-checkout   # keep branch completion on gco <tab>

# Auto activate/deactivate ./.venv on cd
# https://dev.to/moniquelive/auto-activate-and-deactivate-python-venv-using-zsh-4dlm
python_venv() {
  if [[ -d ./.venv ]]; then
    source ./.venv/bin/activate > /dev/null 2>&1
  else
    deactivate > /dev/null 2>&1
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv

gitls() {
  git ls-tree --name-only HEAD "$1" | while read filename; do
    echo "$(git log -1 --format="%ai" -- $filename) $filename"
  done
}

# Man colors
man() {
  LESS_TERMCAP_mb=$'\e[01;31m' \
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[45;93m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[4;93m' \
  command man "$@"
}

dev() {
  local vm=dev
  if virsh domstate "$vm" 2>/dev/null | command grep -qx 'running'; then
    virsh-ssh "$vm" -L 1455:localhost:1455
  else
    virsh start "$vm"
  fi
}

# ---------------------------------------------------------------------------
# Git worktrees
# ---------------------------------------------------------------------------
wt() {
  local dir
  if (( $# )); then
    dir=$(git worktree list | awk '{print $1}' | grep -i -- "$1" | head -1)
  else
    dir=$(git worktree list | fzf --height 40% --reverse | awk '{print $1}')
  fi
  [[ -n $dir ]] && cd "$dir"
}

wtD() {
  local name=${1:?usage: wtD <worktree>}
  local dir=$name
  [[ -d $dir ]] || dir=${WT_BASE:?wtD: WT_BASE is not set}/$name
  # don't be standing in it when it goes
  [[ $PWD/ == $dir/* ]] && cd $(git worktree list --porcelain | sed -n '1s/^worktree //p')
  git worktree remove "$dir"
}

wtco() {
  local name=${1:?usage: wtco <branch> [from]}
  local base=${WT_BASE:?wtco: WT_BASE is not set}
  local dir=$base/$name

  # base for a new branch: $2 if given, else the current branch/commit
  local from=$2
  if [[ -z $from ]]; then
    from=$(git rev-parse --abbrev-ref HEAD) || return 1
    [[ $from == HEAD ]] && from=$(git rev-parse --short HEAD)   # detached
  elif ! git rev-parse --verify --quiet "$from^{commit}" >/dev/null; then
    echo "wtco: unknown ref '$from'" >&2; return 1
  fi

  mkdir -p ${dir:h} || return 1

  # first remote (origin preferred) that has a tracking ref for $name
  local remote r
  for r in origin ${(f)"$(git remote)"}; do
    if git show-ref --verify --quiet "refs/remotes/$r/$name"; then
      remote=$r; break
    fi
  done

  if git show-ref --verify --quiet "refs/heads/$name"; then
    git worktree add "$dir" "$name" || return 1              # local branch exists
  elif [[ -n $remote ]]; then
    git worktree add --track -b "$name" "$dir" "$remote/$name" || return 1  # upstream only
  else
    git worktree add -b "$name" "$dir" "$from" || return 1   # new branch off current
  fi

  # share the source checkout's virtualenv with the worktree
  local main
  main=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
  if [[ -d $main/.venv && ! -e $dir/.venv ]]; then
    ln -s "$main/.venv" "$dir/.venv"
  fi

  cd "$dir"
}

# Look up a CVE in NVD
cve() {
  local id=${1:?usage: cve <CVE-ID>}
  curl -fsS "https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=${id:u}" \
    | jq '.vulnerabilities[0].cve | {id, descriptions: .descriptions[0].value, metrics}'
}

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------
# Shift+Arrow word jumps over ssh
bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word

#zprof
