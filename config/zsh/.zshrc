#==============================================
# Key binds (bash の .inputrc 相当)
#==============================================
# Vi like keybind
bindkey -v
KEYTIMEOUT=1 # ESC 後の待ち時間 10ms (inputrc の keyseq-timeout 5 相当)
# モード表示 (show-mode-in-prompt) は starship の [character] が担当する

# 履歴検索後にカーソルを行末へ移動させる版 (zsh 標準添付の関数)
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# コマンドモード
bindkey -M vicmd -r 'v' # visual モードを無効化 (inputrc の "v": "" 相当)
bindkey -M vicmd '^P' history-beginning-search-backward-end
bindkey -M vicmd '^N' history-beginning-search-forward-end
bindkey -M vicmd 'L' vi-forward-word
bindkey -M vicmd 'H' vi-backward-word

# 挿入モード
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end
# vi 流の「今回挿入した分しか消せない」制約を外す
bindkey -M viins '^?' backward-delete-char # Backspace
bindkey -M viins '^H' backward-delete-char # Ctrl+H (端末によってはこちらが来る)
bindkey -M viins '^W' backward-kill-word   # Ctrl+W
bindkey -M viins '^U' backward-kill-line   # Ctrl+U

#==============================================
# Options
#==============================================
# automatically push directory stack
setopt auto_pushd
setopt pushd_ignore_dups
# extended glob
setopt extended_glob
#-------------------------
# History
#-------------------------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extended_history


#==============================================
# Appearance
#==============================================
if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi
#==============================================
# Completions
#==============================================
fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
autoload -Uz compinit && compinit

# linear completion
if command -v linear >/dev/null 2>&1; then
	eval "$(linear completions zsh)"
fi

# tailscale
if command -v tailscale >/dev/null 2>&1; then
	eval "$(tailscale completion zsh)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

# herdr
if command -v herdr >/dev/null 2>&1; then
	eval "$(herdr completion zsh)"
fi

# colcon, ros2
if command -v register-python-argcomplete >/dev/null 2>&1; then
	eval "$(register-python-argcomplete --shell zsh ros2)"
	eval "$(register-python-argcomplete --shell zsh colcon)"
fi

# gitbook
if command -v gitbook >/dev/null 2>&1; then
	eval "$(gitbook completion zsh)"
fi

#=======================================================
# zoxide
#=======================================================
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh --cmd j)"
fi

#=======================================================
# direnv
#=======================================================
if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook zsh)"
fi

#=======================================================
# Plugins
#=======================================================
NIX_SHARE="$HOME/.nix-profile/share"
fpath=("$NIX_SHARE/zsh/site-functions" $fpath)

# LS_COLORS を生成 (bash の alias.sh と同じ)
if command -v dircolors >/dev/null 2>&1; then
	eval "$(dircolors -b)"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"               # ファイル名を ls と同じ色に
zstyle ':completion:*' group-name ''                                  # 種類ごとに分けて見出しを付ける
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'    # 見出し (黄)
zstyle ':completion:*:messages' format '%F{blue}-- %d --%f'          # 案内 (青)
zstyle ':completion:*:warnings' format '%F{red}-- No Candidate --%f'      # 該当なし (赤)
zstyle ':completion:*:corrections' format '%F{green}-- %d (Error %e) --%f'
zstyle ':completion:*:options' list-colors '=(#b)(-[^ ]#)*=0=36'      # オプション名を水色に
zstyle ':completion:*:commands' list-colors '=*=1;32'                 # コマンド名を太字緑に

#---------------- autosuggestions ----------------
if [ -f "$NIX_SHARE/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
	ZSH_AUTOSUGGEST_STRATEGY=(history completion) # 履歴になければ補完候補を出す
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'        # 提案の色 (暗い灰色)
	ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40            # 長い行では提案しない (速度対策)
	source "$NIX_SHARE/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
	bindkey -M viins '^F' autosuggest-accept # 提案を丸ごと採用
	bindkey -M viins '^[f' forward-word      # Alt+f で一語だけ採用
fi

#---------------- zsh-abbr (autosuggestions の後、構文ハイライトの前) ----------------
if [ -f "$NIX_SHARE/zsh/zsh-abbr/zsh-abbr.plugin.zsh" ]; then
	ABBR_USER_ABBREVIATIONS_FILE="$HOME/dotfiles/config/zsh/abbr.zsh" # 略語の定義は dotfiles 内で管理
	ABBR_SET_EXPANSION_CURSOR=1 # 展開文字列中の % の位置にカーソルを置く
	ABBR_QUIET=1                # 起動時や add 時の案内を抑える
	source "$NIX_SHARE/zsh/zsh-abbr/zsh-abbr.plugin.zsh"
	# 既定の割り当て: Space で展開、Enter で展開して実行、Ctrl+Space で展開せず空白
fi

#---------------- syntax highlight ----------------
if [ -f "$NIX_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
	source "$NIX_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
