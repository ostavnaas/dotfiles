
# Time zsh
# $ time  zsh -i -c exit
export ZSH=/home/oves/.oh-my-zsh
ZSH_THEME="agnoster"

plugins=(
  git
  z
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_workrc

export PATH=$PATH:~/gitlab/scripts:/usr/local/go/bin:/home/oves/.bin/bin:/snap/bin

# Add nodejs
export PATH=$PATH:/usr/local/lib/nodejs/node-v10.16.3-linux-x64/bin/

# Go
export GOROOT=/usr/local/go
export GOPATH=~/golang

# History
export HISTSIZE=100000
export HISTFILESIZE=100000


# Do not share history between windows
setopt no_share_history
unsetopt share_history

alias less='less -S'

# Make git branch use cat
#export GIT_PAGER=cat
alias rebase='git fetch; git rebase -i origin/production'
alias fetch'=git fetch origin production'
alias xclip="ssh -X  laptop  'DISPLAY=:0 xsel' 2> /dev/null"

# *Nix safe password
pwgen() {
  /usr/bin/pwgen -r "\"\'\$\,\[\]\*\?\{\}\~\#\%\\\<\>\|\^\;\`" -y $1
}

rebase-all() {
	git fetch origin production
	for b in $(git branch); do
		git checkout $b
		git rebase origin/production > /dev/null 2>&1 || git rebase --abort
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
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

if [ -z $TMUX ]; then
  tmux a -t 0
 fi


if [ $commands[aws] ]; then source /usr/local/bin/aws_zsh_completer.sh; fi

# K8s
if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi
alias k=kubectl
alias kx=kubectx

# kubectl Autocompletion
if [ $commands[k] ]; then
  autoload -U compinit && compinit
  complete -F __start_kubectl k
fi

# Vault Autocompletion
if [ $commands[vault] ];then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/bin/vault vault
fi


# For eyaml to work
GPG_TTY=$(tty)
export GPG_TTY

# Remove user@host from prompt
DEFAULT_USER=""
prompt_context(){}
