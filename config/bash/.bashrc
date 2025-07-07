#-------------------- Development Environmen Setup ---------------------
if command -v mise > /dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

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

if command -v lsd > /dev/null 2>&1; then
    alias ls='lsd'
    alias ll='lsd -la'
    alias la='lsd -A'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
fi

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
if [ -d "$HOME"/dotfiles/config/bash/completions ];then
    script_dir="$HOME"/dotfiles/config/bash/completions
    if [ -f "$script_dir/git-completion.sh" ];then
        source "$script_dir/git-completion.sh"
    fi
fi

#=======================================================
# PATH Configuration --->> see $HOME/.bash_profile
#=======================================================
