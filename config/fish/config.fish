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

