if command -v starship &> /dev/null; then
    # Startship
    export STARSHIP_CONFIG="$HOME"/.config/starship/starship.toml
    if command -v starship &> /dev/null;then
        eval "$(starship init bash)"
    fi
else
    # No Startship
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac
    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            color_prompt=yes
        else
            color_prompt=
        fi
    fi
    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
            ;;
    *)
        ;;
    esac
fi
