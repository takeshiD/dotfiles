# Alias
if command -v lsd &> /dev/null
    alias ll='lsd -la'
    alias la='lsd --tree --depth 2'
else
    alias ll='ls -alF'
    alias la='ls -A'
end
if command -v bat &> /dev/null
    alias cat='bat'
end

zoxide init fish | source
starship init fish | source
