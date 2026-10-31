if command -v eza >/dev/null 2>&1; then
	abbr ls='eza -a'
	abbr ll='eza -la'
	abbr la='eza -la --tree -L 2'
else
	# abbr ls='ls'
	abbr ll='ls -alF'
fi

if command -v bat >/dev/null 2>&1; then
	abbr cat='bat'
fi

if command -v man >/dev/null 2>&1; then
	abbr man='batman'
fi

if command -v taskwarrior-tui >/dev/null 2>&1; then
	abbr tt='taskwarrior-tui'
fi

if command -v tv && command -v nix-search-tv >/dev/null 2>&1; then
	abbr "nix fuzzy"="nix-search-tv print | tv --inline"
fi

abbr cdr="cd $(git rev-parse --show-toplevel)"
abbr "du"="dust --reverse"
abbr "df"="duf"
abbr "lg"="lazygit"
abbr "bc"="bc -l"
