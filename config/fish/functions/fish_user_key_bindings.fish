function fish_user_key_bindings
    fish_vi_key_bindings --no-erase
    bind -M default H beginning-of-line
    bind -M default L end-of-line
    bind -M visual H beginning-of-line
    bind -M visual L end-of-line
    bind -M insert ctrl-p history-search-backward
    bind -M insert ctrl-n history-search-forward
    bind -M insert ctrl-l accept-autosuggestion
end
