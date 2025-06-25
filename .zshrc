export NVM_LAZY_LOAD=true
export TERM=xterm-256color
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="cloud"
plugins=(git zsh-autosuggestions zsh-nvm)

source $ZSH/oh-my-zsh.sh
# Auto-start tmux with -u if not already inside tmux
if [[ -z "$TMUX" ]] && command -v tmux &> /dev/null; then
  exec tmux -u
fi

# Helpers
grc(){
  gh repo clone pawelborkar/"$1"
}

gt()
{
	cd ~/Projects/"$1" || ~/Projects
	echo "------------contents-------------"
	ls
	echo "---------------------------------"
}

lvo(){
  cd ~/Projects/"$1" && lvim .
}

rcc(){
  mkdir -p "$1" && cd -P -- "$1" && touch "$1".tsx
}

mkcd()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

#Example aliases
alias rt=". ~/.zshrc"
alias lv="lvim"
alias lm="cd ~/Projects/minit/ && lv ."
alias lvc="lvim $HOME/.config/lvim/config.lua"
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
alias sdi="sudo dpkg -i"
alias dcu="sudo docker compose up"
alias dcd="sudo docker compose down"
alias gac="gaa; gcmsg"
alias ptd="pnpm tauri dev"
alias ptb="pnpm tauri build"
alias lg='lazygit'
alias ldd='lazydocker'
alias x="exit"
alias lcd='xdg-open http://localhost:3000/'
alias lzd='lazydocker'

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

fpath+=${ZDOTDIR:-~}/.zsh_functions

export PNPM_HOME="$HOME/.local/share/pnpm"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "$HOME/.deno/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.deno/env"
