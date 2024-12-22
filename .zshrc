# time zsh
#zmodload zsh/zprof
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
# fzf

plugins=(
  git
  docker-compose
)

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# pipenv
export PIPENV_VENV_IN_PROJECT=1

if [ -f ~/.zsh_workrc ];then
  source ~/.zsh_workrc
fi




export PATH=$PATH:$HOME/.local/bin/:$HOME/go/bin:/opt/node/bin
# Go
export GOROOT=/usr/local/go
#export GOPATH=~/golang
export GO111MODULE=on

# History
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILESIZE=1000000
export EDITOR=nvim

# https://github.com/cheat/cheat/
export CHEAT_CONFIG_PATH="~/github/ostavnaas/dotfiles/cheat/conf.yml"

export LIBVIRT_DEFAULT_URI="qemu:///system"
alias gcam='git commit --amend --no-edit'
alias ip3='ipython3'

# https://documen.tician.de/pudb/starting.html
export PYTHONBREAKPOINT="pudb.set_trace"


# https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Do not share history between windows
#unsetopt no_share_history
#setopt share_history

alias less='less -S'
alias df='df --exclude-type=squashfs'

alias dotfiles='cd ~/github/ostavnaas/dotfiles'
alias grafana='docker compose --file ~/github/ostavnaas/dotfiles/docker/grafana/docker-compose.yml up'
alias vim='nvim'


# Make git branch use cat
#export GIT_PAGER=cat
alias xclip="ssh -X  laptop  'DISPLAY=:0 xsel' 2> /dev/null"

# *Nix safe password
pwgen() {
  /usr/bin/pwgen -r "\"\'\$\,\[\]\*\?\{\}\~\#\%\\\<\>\|\^\;\`\/" -y $1
}


up() {
  docker compose up
}

down() {
  docker compose down
}



# SSH-agent socket
if [ -z $SSH_AUTH_SOCK ]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi




alias k=kubectl
alias kx=kubectx


# For eyaml to work
GPG_TTY=$(tty)
export GPG_TTY

# Remove user@host from prompt
DEFAULT_USER=""
prompt_context(){}



# Autocomplete
if [[ -d $HOME/.zsh-completions ]];  then
fpath=($fpath $HOME/.zsh-completions)
fi

# Kubectl
if (which kubectl > /dev/null 2>&1 ); then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi




# https://github.com/cheat/cheat
if [ -e ~/github/ostavnaas/dotfiles/cheat/cheat.zsh ]; then
  source ~/github/ostavnaas/dotfiles/cheat/cheat.zsh
fi

source <(stern --completion=zsh)

#autoload -Uz compinit

compinit -u
#autoload -Uz +X compinit && compinit
#autoload -Uz +X bashcompinit && bashcompinit

# zprof

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh#L33
# Override func to include production branch as main branch
# Check if main exists and use instead of master
function git_main_branch() {
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

# Needed for kops to work with aws sso login
export AWS_SDK_LOAD_CONFIG=1


# Kodos https://dev.to/moniquelive/auto-activate-and-deactivate-python-venv-using-zsh-4dlm
# Autoload Python venv
python_venv() {
  MYVENV=./.venv
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
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
        export LESS_TERMCAP_mb=$'\e[01;31m'
        export LESS_TERMCAP_md=$'\e[01;31m' \
        export LESS_TERMCAP_me=$'\e[0m' \
        export LESS_TERMCAP_se=$'\e[0m' \
        export LESS_TERMCAP_so=$'\e[45;93m' \
        export LESS_TERMCAP_ue=$'\e[0m' \
        export LESS_TERMCAP_us=$'\e[4;93m' \

        command man "$@"
}
#zprof
