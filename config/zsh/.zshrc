#==============================================
# Prifiling
#==============================================
zmodload zsh/zprof
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

# Vi normal mode
bindkey -M vicmd -r 'v' # visual モードを無効化 (inputrc の "v": "" 相当)
bindkey -M vicmd '^P' history-beginning-search-backward-end
bindkey -M vicmd '^N' history-beginning-search-forward-end
bindkey -M vicmd 'L' vi-forward-word
bindkey -M vicmd 'H' vi-backward-word

# Vi insert mode
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end
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
# Alias
#==============================================
alias grep="grep --color"

#==============================================
# Completions
#==============================================
fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
autoload -Uz compinit && compinit

# 補完スクリプトを生成してファイルに保存し、次回以降はそれを読み込む
# 使い方: _cache_completion <保存名> <コマンド> [引数...]
# 実行ファイルの実体パスが変わった (nix で更新された) か、
# 実行ファイルが保存ファイルより新しくなったときだけ作り直す
# 強制的に作り直す場合: rm ~/dotfiles/config/zsh/completions/*
ZSH_COMPLETION_CACHE_DIR="$HOME/dotfiles/config/zsh/completions"
_cache_completion() {
	local name=$1 cmd=$2
	shift
	local bin=${commands[$cmd]}
	[[ -n $bin ]] || return
	local cache="$ZSH_COMPLETION_CACHE_DIR/_$name.zsh"
	local stamp="# source: ${bin:A}"
	if [[ ! -s $cache || $bin -nt $cache || "$(head -n 1 $cache)" != "$stamp" ]]; then
		mkdir -p $ZSH_COMPLETION_CACHE_DIR
		{ print -r -- $stamp; "$@" 2>/dev/null } >| $cache
	fi
	source $cache
}

# linear
_cache_completion linear linear completions zsh

# tailscale
_cache_completion tailscale tailscale completion zsh

# fzf
if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

# herdr
_cache_completion herdr herdr completion zsh

# colcon, ros2
_cache_completion ros2 register-python-argcomplete --shell zsh ros2
_cache_completion colcon register-python-argcomplete --shell zsh colcon

# gitbook
_cache_completion gitbook gitbook completion zsh

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
# awsr
#=======================================================
if command -v aws_completer > /dev/null; then
    complete -C aws_completer awsr
fi

#=======================================================
# Plugins
#=======================================================
# [zsh-completions](https://github.com/zsh-users/zsh-completions)
NIX_SHARE="$HOME/.nix-profile/share"
fpath=("$NIX_SHARE/zsh/site-functions" $fpath)

# LS_COLORS を生成 (bash の alias.sh と同じ)
if command -v dircolors >/dev/null 2>&1; then
	eval "$(dircolors -b)"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"              # ファイル名を ls と同じ色に
zstyle ':completion:*' group-name ''                                 # 種類ごとに分けて見出しを付ける
zstyle ':completion:*' rehash true
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'    # 見出し (黄)
zstyle ':completion:*:messages' format '%F{blue}-- %d --%f'          # 案内 (青)
zstyle ':completion:*:warnings' format '%F{red}-- No Candidate --%f' # 該当なし (赤)
zstyle ':completion:*:corrections' format '%F{green}-- %d (Error %e) --%f'
zstyle ':completion:*:options' list-colors '=(#b)(-[^ ]#)*=0=36' # オプション名を水色に
zstyle ':completion:*:commands' list-colors '=*=1;32'            # コマンド名を太字緑に

# completion menu select
# Tab: next candidate, Shift+Tab: prev candidate
zmodload zsh/complist
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

#---------------- autosuggestions ----------------
if [ -f "$NIX_SHARE/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
	ZSH_AUTOSUGGEST_STRATEGY=(history completion) # 履歴になければ補完候補を出す
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'        # 提案の色 (暗い灰色)
	ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40            # 長い行では提案しない (速度対策)
	source "$NIX_SHARE/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
	bindkey -M viins '^L' autosuggest-accept # 提案を丸ごと採用
	bindkey -M viins '^[f' forward-word      # Alt+f で一語だけ採用
fi

#---------------- zsh-abbr (autosuggestions の後、構文ハイライトの前) ----------------
if [ -f "$NIX_SHARE/zsh/zsh-abbr/zsh-abbr.plugin.zsh" ]; then
	ABBR_USER_ABBREVIATIONS_FILE="$HOME/dotfiles/config/zsh/abbr.zsh" # 略語の定義は dotfiles 内で管理
	ABBR_SET_EXPANSION_CURSOR=1                                       # 展開文字列中の % の位置にカーソルを置く
	ABBR_QUIET=1                                                      # 起動時や add 時の案内を抑える
	source "$NIX_SHARE/zsh/zsh-abbr/zsh-abbr.plugin.zsh"
	# 既定の割り当て: Space で展開、Enter で展開して実行、Ctrl+Space で展開せず空白
    # sudoで展開しない
    typeset -ga ABBR_REGULAR_ABBREVIATION_SCALAR_PREFIXES=()
fi

#---------------- syntax highlight ----------------
if [ -f "$NIX_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
	source "$NIX_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# pnpm
export PNPM_HOME='/home/tkcd/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# go
if command -v go > /dev/null; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi
# pnpm end

#=======================================================
# ESP32 Setup
#=======================================================
_cache_completion espup espup completions zsh
_cache_completion espflash espflash completions zsh
source "$HOME/export-esp.sh"

zprof
