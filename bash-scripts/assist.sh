function helpmsg(){
    echo -e "Usage: assist [--help | -h]
    Options:
        -h, --help         Show this message

    Requirements:
        * gemini-cli
            > repository: https://github.com/reugn/gemini-cli.git
            > dependencies:
            >       go 1.21 later
            >       Gemini API Key: create a key Google AI Studio
            > installation:
            >       $ go install github.com/reugn/gemini-cli/cmd/gemini@latest
        * trans-shell
            > repository: https://github.com/soimort/translate-shell
            > dependencies:
            >       awk 4.0 later
            >       bash or zsh
            >       rlwrap
            > installation:
            >       $ git clone https://github.com/soimort/translate-shell
            >       $ cd translate-shell/
            >       $ make
            >       $ [sudo] make install"
}

################# Argument Parser ###############
while [[ "$#" -gt 0 ]];do
    case "$1" in
        --help|-h)
            helpmsg
            exit 1
            ;;
        -*|--*=)
            echo "Error: Unsupported flag $1" >&2
            helpmsg
            exit 1
            ;;
       *)
            echo "Error: Unsupported positional argument $1"
            helpmsg
            exit 1
            ;;
    esac
    shift
done
tmux new-window -n 'AI&Trans-Assist'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "trans en:ja -I" C-m
tmux select-pane -t 1
tmux send-keys gemini C-m
