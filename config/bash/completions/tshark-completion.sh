###-begin-tshark-completions-###
# tshark の bash 補完
# 選択肢はできる限り tshark 本体から動的に取得する（初回のみ実行して変数に保持する）

_tshark_completions()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # 直前の選択肢に応じた引数の補完
    case "${prev}" in
        -i|--interface)
            # tcpdump の補完と同じく bash-completion の補助関数で通信装置を候補にする
            if declare -F _available_interfaces > /dev/null; then
                _available_interfaces -a
            else
                COMPREPLY=( $(compgen -W "$(ls /sys/class/net 2>/dev/null)" -- "${cur}") )
            fi
            return 0
            ;;
        -r|--read-file)
            # 捕獲済みの記録を読み込む
            COMPREPLY=( $(compgen -f -- "${cur}") )
            return 0
            ;;
        -w|-H|-K|--log-file|--export-tls-session-keys)
            COMPREPLY=( $(compgen -f -- "${cur}") )
            return 0
            ;;
        --temp-dir)
            COMPREPLY=( $(compgen -d -- "${cur}") )
            return 0
            ;;
        -F)
            # 保存形式の一覧
            if [ -z "${_tshark_file_types}" ]; then
                _tshark_file_types=$(tshark -F 2>&1 | awk '/ - / {print $1}')
            fi
            COMPREPLY=( $(compgen -W "${_tshark_file_types}" -- "${cur}") )
            return 0
            ;;
        -T)
            COMPREPLY=( $(compgen -W "pdml ps psml json jsonraw ek tabs text fields" -- "${cur}") )
            return 0
            ;;
        -z)
            # 統計の一覧
            if [ -z "${_tshark_statistics}" ]; then
                _tshark_statistics=$(tshark -z help 2>&1 | awk 'NR > 1 {print $1}')
            fi
            COMPREPLY=( $(compgen -W "${_tshark_statistics}" -- "${cur}") )
            return 0
            ;;
        -G)
            # 一覧出力の種類
            if [ -z "${_tshark_reports}" ]; then
                _tshark_reports=$(tshark -G help 2>&1 | awk '$1 == "-G" {print $2}')
            fi
            COMPREPLY=( $(compgen -W "${_tshark_reports}" -- "${cur}") )
            return 0
            ;;
        -t)
            COMPREPLY=( $(compgen -W "a ad adoy d dd e r u ud udoy" -- "${cur}") )
            return 0
            ;;
        -u)
            COMPREPLY=( $(compgen -W "s hms" -- "${cur}") )
            return 0
            ;;
        --hexdump)
            COMPREPLY=( $(compgen -W "all frames ascii delimit noascii help" -- "${cur}") )
            return 0
            ;;
        --log-level|--log-fatal)
            COMPREPLY=( $(compgen -W "noisy debug info message warning critical error" -- "${cur}") )
            return 0
            ;;
        -C)
            # 設定一式の一覧
            if [ -d "${HOME}/.config/wireshark/profiles" ]; then
                COMPREPLY=( $(compgen -W "$(ls "${HOME}/.config/wireshark/profiles" 2>/dev/null)" -- "${cur}") )
            fi
            return 0
            ;;
        -a|--autostop)
            COMPREPLY=( $(compgen -W "duration: filesize: files: packets:" -- "${cur}") )
            return 0
            ;;
        -b|--ring-buffer)
            COMPREPLY=( $(compgen -W "duration: filesize: files: packets: interval:" -- "${cur}") )
            return 0
            ;;
        -N)
            COMPREPLY=( $(compgen -W "m n N t d v" -- "${cur}") )
            return 0
            ;;
        -f|-Y|--display-filter|-R|--read-filter|-e|-j|-J|-O|-d|-s|--snapshot-length|-c|-M|-y|--linktype|-B|--buffer-size|-o|-X|-U|-S|-W|--capture-comment|--enable-protocol|--disable-protocol|--only-protocols|--enable-heuristic|--disable-heuristic|--export-objects|--elastic-mapping-filter|--time-stamp-type|--update-interval|--log-domains|--log-fatal-domains|--log-debug|--log-noisy)
            # 自由入力の引数は補完しない
            return 0
            ;;
    esac

    # 選択肢そのものの補完
    if [[ "${cur}" == -* ]]; then
        local opts="
            -i --interface -f -s --snapshot-length -p --no-promiscuous-mode
            -I --monitor-mode -B --buffer-size -y --linktype --time-stamp-type
            -D --list-interfaces -L --list-data-link-types --list-time-stamp-types
            --update-interval
            -c -a --autostop -b --ring-buffer
            -r --read-file
            -2 -M -R --read-filter -Y --display-filter -n -N -d -H
            --enable-protocol --disable-protocol --only-protocols
            --disable-all-protocols --enable-heuristic --disable-heuristic
            -w --capture-comment -C -F -V -O -P --print -S -x --hexdump
            -T -j -J -e -E -t -u -l -q -Q -g -W -X -U -z
            --export-objects --export-tls-session-keys --color
            --no-duplicate-keys --elastic-mapping-filter --temp-dir
            --log-level --log-fatal --log-domains --log-fatal-domains
            --log-debug --log-noisy --log-file
            -h --help -v --version -o -K -G
        "
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
        return 0
    fi

    # 既定は入力対象の名前を補完する
    COMPREPLY=( $(compgen -f -- "${cur}") )
    return 0
}
complete -o default -F _tshark_completions tshark
###-end-tshark-completions-###
