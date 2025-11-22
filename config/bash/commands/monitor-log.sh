function watch-jsonl() {
    local target="$1"
    tail -f "$target" | fzf \
        --preview='echo {} | jq --color-output .' \
        --preview-window=top:50%:wrap \
        --bind change:refresh-preview
}

