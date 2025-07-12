# Alias
if command -v lsd &> /dev/null
    alias ll='lsd -la'
    alias la='lsd -A'
    alias lt='lsd --tree --depth 2'
else
    alias ll='ls -alF'
    alias la='ls -A'
end
if command -v bat &> /dev/null
    alias cat='bat'
end

# fish_vi_keybindings
starship init fish | source
