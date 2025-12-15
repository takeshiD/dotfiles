nix-fzf() {
    local repos=(
    "github:NixOS/templates"
    "github:the-nix-way/dev-templates"
    "github:nix-community/templates"
    )
    local templates=""
    for repo in "${repos[@]}"; do
    local result=$(nix flake show "$repo" --json 2>/dev/null | \
        jq -r --arg repo "$repo" '.templates // {} | keys[] | "\($repo)#\(.)"')
        templates+="${result}"$'\n'
    done
    local selected=$(echo "$templates" | sed '/^$/d' | sort | \
    fzf --height 40% --reverse --border --prompt "Template: ")
    [[ -n "$selected" ]] && nix flake init -t "$selected"
}
