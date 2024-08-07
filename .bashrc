#=======================================================
# Misc
#=======================================================
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
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#-------------------- Completion ---------------------
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#=======================================================
# Look and Feel
#=======================================================
#-------------- Prompt : no plugin ---------------
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
*)
    ;;
esac

#-------------- Prompt : plugin ---------------
#------ starship ------
export STARSHIP_CONFIG="$HOME"/.config/starship/starship.toml
if [[ -x $(which starship) ]];then
    eval "$(starship init bash)"
fi

#-------------- Scripts load ---------------
if [[ -d "$HOME"/dotfiles/bash-scripts ]];then
    script_dir="$HOME"/dotfiles/bash-scripts
    if [[ -f "$script_dir/24-bit-color.sh" ]];then
        source "$script_dir/24-bit-color.sh"
    fi
    if [[ -f "$script_dir/yy.sh" ]];then
        source "$script_dir/yy.sh"
    fi
    #------ tmux command alias ------
    alias assist='$script_dir/assist.sh'
fi

#=======================================================
# PATH Configuration --->> see $HOME/.bash_profile
#=======================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
