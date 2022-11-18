# time zsh
# zmodload zsh/zprof
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"
# fzf

plugins=(
  git
  z
  docker
  docker-compose
)

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# pipenv
export PIPENV_VENV_IN_PROJECT=1

if [ -f ~/.zsh_workrc ];then
  source ~/.zsh_workrc
fi


export PATH=$PATH:$HOME/.local/bin/:$HOME/go/bin
# Go
export GOROOT=/usr/local/go
#export GOPATH=~/golang
export GO111MODULE=on

# History
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILESIZE=1000000

export CHEAT_CONFIG_PATH="~/github/ostavnaas/dotfiles/cheat/conf.yml"
export LIBVIRT_DEFAULT_URI="qemu:///system"



# Do not share history between windows
#setopt no_share_history
#unsetopt share_history
unsetopt no_share_history
setopt share_history

alias less='less -S'
alias df='df --exclude-type=squashfs'

alias tmuxlogger='tmux pipe-pane -o "cat >>~/tmux_output"'
alias notmuxlogger='tmux pipe-pane'

#alias yq='yq r -C'
venv()
	if [ -f .venv/bin/activate ];then
		source .venv/bin/activate
	else
		source $(find ./venv_*/bin -name "activate")
	fi

# Make git branch use cat
#export GIT_PAGER=cat
#alias rebase='git fetch; git rebase -i origin/production'
alias fetch'=git fetch origin production'
alias xclip="ssh -X  laptop  'DISPLAY=:0 xsel' 2> /dev/null"

# *Nix safe password
pwgen() {
  /usr/bin/pwgen -r "\"\'\$\,\[\]\*\?\{\}\~\#\%\\\<\>\|\^\;\`\/" -y $1
}


urb() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  REMOTE="origin"
  if git remote -v |grep upstream >/dev/null 2>&1; then
	  REMOTE="upstream"
	fi
  git fetch upstream $HEAD
  git rebase -i upstream/$HEAD
}

ur() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  REMOTE="origin"
  if git remote -v |grep upstream >/dev/null 2>&1; then
	  REMOTE="upstream"
	fi
  git fetch $REMOTE $HEAD
  git rebase $REMOTE/$HEAD
}

rebase() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  git fetch origin $HEAD
  git rebase -i origin/$HEAD
}

ur-all() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  git fetch upstream $HEAD
  for b in $(git branch); do
    git checkout $b
    git rebase upstream/$HEAD > /dev/null 2>&1 || git rebase --abort
  done
}

bastion() {
	ssh -D 1080 -q -N $1 &
}

rebase-all() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  git fetch origin $HEAD
  for b in $(git branch); do
    git checkout $b
    git rebase origin/$HEAD > /dev/null 2>&1 || git rebase --abort
  done
}

gbcalc() {
  echo $1 | awk '{ sum=$1 ; hum[1024^3]="Gb";hum[1024^2]="Mb";hum[1024]="Kb"; for (x=1024^3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'
}


# Calc $ = 1+1 will output 2
\=() {
  echo $@ | bc
}


# SSH-agent socket
if [ -z $SSH_AUTH_SOCK ]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi



# Attatch tmux session if one exists
#if [ -z $TMUX ]; then
#  tmux a -t 0
#fi



# K8s
alias k=kubectl
alias kx=kubectx

# kubectl Autocompletion


# For eyaml to work
GPG_TTY=$(tty)
export GPG_TTY

# Remove user@host from prompt
DEFAULT_USER=""
prompt_context(){}



# Autocomplete
#if [[ -d $HOME/.zsh-completions ]];  then
#  fpath=($fpath $HOME/.zsh-completions)
#fi

if (which vault >/dev/null 2>&1);then
  complete -o nospace -C $(which vault) vault
fi

#if (which aws > /dev/null 2>&1 ); then
#  source /usr/local/bin/aws_zsh_completer.sh
#fi
#complete -C '/home/oves/.local/bin/aws_completer' aws

if (which kubectl > /dev/null 2>&1 ); then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi

if (which az > /dev/null 2>&1); then
  source ~/.zsh-completions/az.completion
fi

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
# end
