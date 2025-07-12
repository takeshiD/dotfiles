if command -v dircolors > /dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if command -v lsd > /dev/null 2>&1; then
    alias ls='lsd -a'
    alias ll='lsd -la'
    alias la='lsd -la --tree --depth 2'
else
    # alias ls='ls'
    alias ll='ls -alF'
fi

if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
fi
