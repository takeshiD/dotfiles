if command -v lsd
    alias ll='lsd -la'
    alias la='lsd -A'
    alias lt='lsd --tree --depth 2'
else
    alias ll='ls -alF'
    alias la='ls -A'
end

if command -v bat
    alias cat='bat'
end

starship init fish | source
