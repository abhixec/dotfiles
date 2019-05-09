# Sets up the working Shell 
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/abhinav/.zshrc'

# Export PATH
#export PATH=~/.local/bin/:$PATH

#Export PATH 
#export PATH=/usr/local/bin/:$PATH

# Export PATH for rust
export PATH=$HOME/.cargo/bin:$HOME/.local/bin/:$PATH

# Export XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME/.config"

# Export ZDOTDIR
#export ZDOTDIR="$HOME/.zsh"
