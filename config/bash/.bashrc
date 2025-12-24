#=======================================================
# Note! PATH Configuration --->> see $HOME/.bash_profile
#=======================================================

# Entry Point
DOTFILES_DIR="$HOME/dotfiles"

# Import Notice Components
source "$DOTFILES_DIR/config/bash/components/notice.sh"

# only apply bashrc when running interactive-mode. 
case $- in
    *i*) ;;
      *) return;;
esac
#----------------- Histroy --------------------
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

#------------------ Misc ----------------------
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#-------------- Alias and Colored -------------
BASH_ALIAS_PATH="$DOTFILES_DIR/config/bash/alias.sh"
if [ -f "$BASH_ALIAS_PATH" ]; then
    source "$BASH_ALIAS_PATH"
    info "Loaded $BASH_ALIAS_PATH"
else
    warning "Not Found $BASH_ALIAS_PATH"
fi

#=======================================================
# Nix Profile
#=======================================================
NIX_PROFILE_PATH="$DOTFILES_DIR/config/bash/nix-profile.sh"
if [ -f "$NIX_PROFILE_PATH" ]; then
    source "$NIX_PROFILE_PATH"
    info "Loaded $NIX_PROFILE_PATH"
else
    warning "Not Found $NIX_PROFILE_PATH"
fi

#=======================================================
# Completion
#=======================================================
# Global Completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi
# Custom Completions
COMPLETION_DIR="$DOTFILES_DIR/config/bash/completions"
if [ -d "$COMPLETION_DIR" ];then
    for completion_file in "$COMPLETION_DIR"/*-completion.sh; do
        # script_dir="$HOME"/dotfiles/config/bash/completions
        if [ -f "$completion_file" ];then
            source "$completion_file"
            info "Loaded $completion_file"
        else
            warning "Not Found $completion_file"
        fi
    done
fi


#=======================================================
# Prompt Look and Feel
#=======================================================
PROMPT_PATH="$DOTFILES_DIR/config/bash/prompt.sh"
if [ -f "$PROMPT_PATH" ];then
    source "$PROMPT_PATH"
    info "Loaded $PROMPT_PATH"
else
    warning "Not Found $PROMPT_PATH"
fi


#=======================================================
# Look and Feel
#=======================================================
if command -v mise > /dev/null 2>&1; then
    eval "$(mise activate bash)"
fi


#=======================================================
# zoxide
#=======================================================
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init bash --cmd j)"
fi


#=======================================================
# direnv
#=======================================================
if command -v direnv > /dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi


#=======================================================
# Custom commands
#=======================================================
COMMANDS_DIR="$DOTFILES_DIR/config/bash/commands"
if [ -d "$COMMANDS_DIR" ]; then
    for command_file in "$COMMANDS_DIR"/*.sh; do
        if [ -f "$command_file" ];then
            source "$command_file"
            info "Loaded $command_file"
        else
            warning "Not Found $command_file"
        fi
    done
fi


# pnpm
export PNPM_HOME="/home/tkcd/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# source ~/.safe-chain/scripts/init-posix.sh # Safe-chain bash initialization script
