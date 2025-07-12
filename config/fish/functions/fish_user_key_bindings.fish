function fish_user_key_bindings
    fish_vi_key_bindings --no-erase
    bind -M default H beginning-of-line
    bind -M default L end-of-line
    bind -M visual H beginning-of-line
    bind -M visual L end-of-line
end
