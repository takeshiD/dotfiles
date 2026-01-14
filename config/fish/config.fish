#=======================================================
# Abbreviation
#=======================================================
if command -v lsd &> /dev/null
    abbr --add ll "lsd -la"
    abbr --add la "lsd --tree --depth 2"
    abbr --add ls "lsd"
else
    abbr --add ll "ls -alF"
    abbr --add la "ls -A"
end

if command -v bat &> /dev/null
    abbr --add cat "bat"
end

#=======================================================
# zoxide
#=======================================================
if command -v zoxide &> /dev/null
    zoxide init fish --cmd j | source
end

#=======================================================
# starship
#=======================================================
if command -v starship &> /dev/null
    starship init fish | source
end

#=======================================================
# direnv
#=======================================================
if command -v direnv &> /dev/null
    direnv hook fish | source
end

