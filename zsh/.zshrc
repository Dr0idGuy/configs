# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  # Get the terminal emulator
  platform='Linux'
  TERM_PROGRAM=$(ps -f -o comm -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed -r 's;:.*$;;gm' | sed -r 's/[-\/]*$//g')
elif [[ "$unamestr" == 'Darwin' ]]; then
  # TERM_PROGRAM should already be set
  platform='Darwin'
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  # on Ubuntu it's in vte-2.91.sh for whatever reason?
  if [[ -s '/etc/profile.d/vte.sh' ]]; then
    Z_VTE_CONF_SETUP_FILE='/etc/profile.d/vte.sh'
  elif [[ -s '/etc/profile.d/vte-2.91.sh' ]]; then
    Z_VTE_CONF_SETUP_FILE='/etc/profile.d/vte-2.91.sh'
  fi

  if [[ -n "$Z_VTE_CONF_SETUP_FILE" ]]; then
    source $Z_VTE_CONF_SETUP_FILE
  fi
fi

# Default in case we don't know if terminal has powerline fonts.
ZSH_THEME="fishy"
Z_DEFAULT_POWERLINE_THEME="agnoster"
if [[ "$TERM_PROGRAM" == 'zsh' ]]; then
  # Once nested: look at parent's process
  TERM_PROGRAM=$(ps -f -o comm -p $(cat /proc/$(echo $PPID)/stat | cut -d \  -f 4) | tail -1 | sed -r 's;:.*$;;gm' | sed -r 's/[-\/]*$//g')
fi
case "$TERM_PROGRAM" in
  'python2'|\
  'terminator'|\
  'iTerm.app'|\
  'gnome-terminal'|\
  'tmux'|\
  'tilix'|\
  'sshd')
    ZSH_THEME="$Z_DEFAULT_POWERLINE_THEME"
    ;;
  'login')
    ZSH_THEME="fishy"
    ;;
  'zsh') # We are nested deeper
    ZSH_THEME="fishy"
    ;;
esac

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

#---------#
# PLUGINS #
#---------#
# oh-my-zsh
plugins=(git command-not-found git-flow-completion python cp colored-man-pages zsh-syntax-highlighting z)
typeset -U plugins
# antigen bundles
antigenplugins=(
  git
  command-not-found
  cp
  z
#  zsh-users/zsh-syntax-highlighting
  colored-man-pages
  peterhurford/git-it-on.zsh
  Tarrasch/zsh-bd
  zdharma/fast-syntax-highlighting
)
typeset -U antigenplugins

#--------------------#
# User configuration #
#--------------------#

# Tmux plugin:
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen-256color"
ZSH_TMUX_AUTOSTART="false"
ZSH_TMUX_AUTOCONNECT="false"

[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc

# Go environment
[ -d $HOME/code/go ] && export GOPATH=$HOME/code/go
[ -d $HOME/code/go/bin ] && path+=($HOME/code/go/bin)

# NVM nodejs
if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# Fix that guake doesn't set TERM properly
# it actually does have 256color...
if [ $TERM_PROGRAM = "python2" ] && [ $TERM = "xterm" ]; then
  TERM=xterm-256color
fi

#----------------#
# Load framework #
#----------------#

# If ~/.antigen, then use that instead of oh-my-zsh
if [ -d $HOME/.antigen ]; then
  if [ -d ~/.antigen/bundles/bhilburn/powerlevel9k ] && [ $ZSH_THEME = "$Z_DEFAULT_POWERLINE_THEME" ]; then
    # More power
    ZSH_THEME="bhilburn/powerlevel9k"
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir_writable dir vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time root_indicator background_jobs battery time)
    #POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=( vi_mode )
    # Specifics
    POWERLEVEL9K_BATTERY_LOW_THRESHOLD=30
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
    POWERLEVEL9K_BATTERY_ICON=""
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    POWERLEVEL9K_SHORTEN_DELIMITER=""
    POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="black"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="242" # dimm gray
    POWERLEVEL9K_EXECUTION_TIME_ICON="⧖ "
    POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON="⇗ "
  fi
  ANTIGEN_CACHE=$HOME/.antigen/init-${TERM_PROGRAM}-$( echo $ZSH_THEME | tr -cd '[[:alnum:]]').zsh
  source $HOME/.antigen/antigen.zsh
  antigen use oh-my-zsh
  for plugin in $antigenplugins; do
    antigen bundle "$plugin"
  done
  antigen theme $ZSH_THEME
  antigen apply
  # Remove paths that start with $HOME/.antigen/
  path=( ${path%$HOME/.antigen/*} )
else
  # Otherwise use oh-my-zsh
  source $ZSH/oh-my-zsh.sh
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Editor
if command -v nvim > /dev/null 2>&1; then
  export EDITOR='nvim'
elif command -v vim > /dev/null 2>&1; then
  export EDITOR='vim'
elif command -v vi > /dev/null 2>&1; then
  export EDITOR='vi'
elif command -v nano > /dev/null 2>&1; then
  export EDITOR='nano'
fi
alias v="$EDITOR"

# ls shortcuts
if command -v exa > /dev/null 2>&1; then
  export Z_LSBASE='exa'
  export Z_LSARGEXTRA='--git'
else
  export Z_LSBASE='ls'
  if [[ "$platform" == "Linux" ]]; then
    export Z_LSARGEXTRA='--color=tty'
  elif [[ "$platform" == "Darwin" ]]; then
    export Z_LSARGEXTRA='-G'
  fi
fi

# ls long, but not too long
# complicated fix to not show too many dotfiles for just 'l'
# does not show hidden files if there are more hidden files than terminal height
function lslbntl() {
  z_tmp_args=()
  for arg in "$@"; do
    if [[ ! "$arg" =~ ^- ]]; then
      z_tmp_args+=($arg)
    fi
  done
  Z_TMP_DOTCOUNT="$(ls -A1 $z_tmp_args | grep '^\.' | wc -l)"
  if [[ "$Z_TMP_DOTCOUNT" -gt "$(tput lines)" ]]; then # there are too many dotfiles lol
    echo "Not showing $Z_TMP_DOTCOUNT hidden listings for $z_tmp_args."
    Z_LSARGS="-lh"
  else
    Z_LSARGS="-lah"
  fi
  $Z_LSBASE $Z_LSARGEXTRA $Z_LSARGS $@
}

alias l="lslbntl"
alias ll="$Z_LSBASE $Z_LSARGEXTRA -lh"
alias la="$Z_LSBASE $Z_LSARGEXTRA -lah"

alias gpg-message="gpg2 -a -es -r"
alias gpg-sign="gpg2 -a -s"
alias a="atom"
alias n="nautilus"
alias m="make"

### PATH configuration
# Keep this clean!
typeset -U path # unique items only in path array

# Add .local/bin to path with priority,
[ -d $HOME/.local/bin ] && path[1,0]=$HOME/.local/bin

# Place home bin at front of path
[ -d $HOME/bin ] && path[1,0]=$HOME/bin

export PATH

# EOF
ZSHRC_LOADED=1

