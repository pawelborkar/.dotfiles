# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color
export NVM_LAZY_LOAD=true

ZSH_THEME="cloud"

plugins=(git zsh-autosuggestions zsh-nvm)

source $ZSH/oh-my-zsh.sh

# Helpers
gt()
{
	cd ~/Projects/"$1" || ~/Projects
	echo "------------contents-------------"
	ls
	echo "---------------------------------"
}

mkcd()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

#Example aliases
alias rt=". ~/.zshrc"
alias lv="lvim"
alias lm="cd ~/minit/ && lv ."
alias lvc="lvim /home/pawel/.config/lvim/config.lua"
alias zshrc="nvim ~/.zshrc"
alias mstart="sudo systemctl start mongod && sudo systemctl status mongod"
alias mstatus="sudo systemctl status mongod"
alias mstop="sudo systemctl stop mongod" 
alias pstatus="sudo systemctl status postgresql"
alias sstatus="sudo systemctl status mysql"
alias dstop="sudo systemctl stop"
alias pstart="sudo systemctl start postgresql && echo 'PostgreSQL Started!!!'"
alias sstart="sudo systemctl start mysql && echo 'MYSQL Started!!!'"
alias pstop="sudo systemctl stop postgresql && echo 'PostgreSQL Stopped...'"
alias sstop="sudo systemctl stop mysql && echo 'MYSQL Stopped...'"
alias prestart="pstop && pstart"
alias srestart="sstop && sstart"
alias dbs="sudo systemctl status mysql cassandra postgresql mongod redis-server"
alias dbstop="sudo systemctl stop mysql cassandra postgresql mongod redis-server"
alias pd="pnpm dev"
alias ps="pnpm start"
alias pi="pnpm install"
alias pf="pnpm format"
alias pl="pnpm lint"
alias pr="pnpm remove"
alias pa="pnpm add"
alias pb="pnpm build"
alias plx="pnpm dlx"
alias ys="yarn start"
alias yd="yarn dev"
alias ya="yarn add"
alias yb="yarn build"
alias yf="yarn format"
alias yl="yarn lint"
alias fsr="uvicorn main:app --reload"
alias cls="clear"
alias rmd="rm -rf"
alias celar="clear"
alias supdate="sudo apt update"
alias supgrade="sudo apt upgrade"
alias suu="supdate; supgrade"
alias sinstall="sudo apt install"
alias suninstall="sudo apt autoremove"
alias rb="sudo service bluetooth restart"
alias python="/usr/bin/python3"
alias sdi="sudo dpkg -i"
alias dcu="sudo docker compose up"
alias dcd="sudo docker compose down"
alias gac="gaa; gcmsg"
alias ptd="pnpm tauri dev"
alias lg='lazygit'
alias x="exit"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

fpath+=${ZDOTDIR:-~}/.zsh_functions

export PATH="/usr/bin/flutter/bin:$PATH"

#asdf
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# pnpm
export PNPM_HOME="/home/pawel/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
