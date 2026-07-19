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
else
    warning "Not Found $BASH_ALIAS_PATH"
fi

#=======================================================
# Nix Profile
#=======================================================
NIX_PROFILE_PATH="$DOTFILES_DIR/config/bash/nix-profile.sh"
if [ -f "$NIX_PROFILE_PATH" ]; then
    source "$NIX_PROFILE_PATH"
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
        if [ -f "$completion_file" ];then
            source "$completion_file"
        else
            warning "Not Found $completion_file"
        fi
    done
fi

# gh completion
if command -v gh > /dev/null 2>&1; then
    eval "$(gh completion --shell bash)"
fi

# glab completion
if command -v glab > /dev/null 2>&1; then
    eval "$(glab completion --shell bash)"
fi

# influx completion
if command -v influx > /dev/null 2>&1; then
    eval "$(influx completion bash)"
fi

# linear completion
if command -v linear > /dev/null 2>&1; then
    eval "$(linear completions bash)"
fi

# delta completion
if command -v delta > /dev/null 2>&1; then
    eval "$(delta --generate-completion bash)"
fi

# ripgrep completion
if command -v rg > /dev/null 2>&1; then
    eval "$(rg --generate=complete-bash)"
fi

# rustup, cargo completion
if command -v rustup > /dev/null 2>&1; then
    eval "$(rustup completions bash rustup)"
    eval "$(rustup completions bash cargo)"
fi

# tailscale
if command -v tailscale > /dev/null 2>&1; then
    eval "$(tailscale completion bash)"
fi

# colcon, ros2
if command -v register-python-argcomplete > /dev/null 2>&1; then
    eval "$(register-python-argcomplete ros2)"
    eval "$(register-python-argcomplete colcon)"
fi

#=======================================================
# Prompt Look and Feel
#=======================================================
PROMPT_PATH="$DOTFILES_DIR/config/bash/prompt.sh"
if [ -f "$PROMPT_PATH" ];then
    source "$PROMPT_PATH"
else
    warning "Not Found $PROMPT_PATH"
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

alias ip='ip -color=auto'

#=======================================================
# Custom commands
#=======================================================
COMMANDS_DIR="$DOTFILES_DIR/config/bash/commands"
if [ -d "$COMMANDS_DIR" ]; then
    for command_file in "$COMMANDS_DIR"/*.sh; do
        if [ -f "$command_file" ];then
            source "$command_file"
        else
            warning "Not Found $command_file"
        fi
    done
fi

# pnpm
export PNPM_HOME="/home/tkcd/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end


if [[ "$DEFAULT_SHELL" == "fish" ]] && [[ $- == *i* && $- != *c* && $- != *s* ]] && command -v fish &>/dev/null && [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" ]]; then
  if shopt -q login_shell; then
    exec fish --login
  else
    exec fish
  fi
fi
