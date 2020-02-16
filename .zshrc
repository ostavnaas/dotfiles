# time zsh
# zmodload zsh/zprof
export ZSH=~/.oh-my-zsh
ZSH_THEME="agnoster"

plugins=(
  git
  z
)

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

if [ -f ~/.zsh_workrc ];then
  source ~/.zsh_workrc
fi

export PATH=$PATH:~/gitlab/scripts:/usr/local/go/bin:~/.bin/bin:/snap/bin

# Add nodejs
export PATH=$PATH:/usr/local/lib/nodejs/node-v10.16.3-linux-x64/bin/

# Go
export GOROOT=/usr/local/go
export GOPATH=~/golang
export PATH=$PATH:~/golang/bin

# History
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILESIZE=1000000


# Do not share history between windows
setopt no_share_history
unsetopt share_history

alias less='less -S'

# Make git branch use cat
#export GIT_PAGER=cat
#alias rebase='git fetch; git rebase -i origin/production'
alias fetch'=git fetch origin production'
alias xclip="ssh -X  laptop  'DISPLAY=:0 xsel' 2> /dev/null"

# *Nix safe password
pwgen() {
  /usr/bin/pwgen -r "\"\'\$\,\[\]\*\?\{\}\~\#\%\\\<\>\|\^\;\`\/" -y $1
}


rebase() {
  HEAD=$(git symbolic-ref refs/remotes/origin/HEAD --short | cut -d \/ -f2)
  git fetch origin $HEAD
  git rebase -i origin/$HEAD
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

if [ -z $TMUX ]; then
  tmux a -t 0
fi



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
if [[ -d $HOME/.zsh_completions ]];  then
fpath=($HOME/.zsh_completions $fpath)
fi

if (which vault >/dev/null 2>&1);then
complete -o nospace -C /usr/bin/vault vault
fi

if (which aws > /dev/null 2>&1 ); then
  source /usr/local/bin/aws_zsh_completer.sh
fi

if (which kubectl > /dev/null 2>&1 ); then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi

autoload -Uz compinit && compinit

# zprof
