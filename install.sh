#! /usr/bin/bash

set -ue

############### Functions ################
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
CLEAR='\e[0m'

function success(){
    echo -e "${GREEN}SUCCESS:${CLEAR} ${1}"
}
function warning(){
    echo -e "${YELLOW}WARNING:${CLEAR} ${1}"
}
function error(){
    echo -e "${RED}ERROR:${CLEAR} ${1}"
}
function info(){
    echo -e "${BLUE}INFO:${CLEAR} ${1}"
}
function title(){
    echo -e "${WHITE}$1${CLEAR}"
}
function mymkdir(){
    mkdir -p $1 2> /dev/null || true
}
function _create_link(){
    local flags="$1"
    local link_src="$2"
    local link_dst="$3"
    if [[ "$#" -ne 3 ]];then
        error "invalid arguments"
        return
    fi
    ln "$flags" "$link_src" "$link_dst" &> /dev/null 
    if [[ $? -eq 0 ]];then
        success "create symlink  ${CYAN}${link_src}${CLEAR} -> ${link_dst}"
    else
        error "symlink failed : ${CYAN}${link_src}${CLEAR} -> ${link_dst}"
    fi
}
function symlink(){
    _create_link -sb "$1" "$2"
}
function dirlink(){
    _create_link -sfn "$1" "$2"
}
function whichdistro(){
    if [[ -f /etc/debian_version ]]; then
        echo debian
        return
    elif [[ -f /etc/arch-release ]]; then
        echo arch
        return
    fi
}
function checkinstall(){
    local distro=$(whichdistro)
    local pkgs="$*"
    case $distro in
        debian)
            sudo apt -y install $pkgs
            ;;
        arch)
            sudo pacman -S --noconfirm --needed $pkgs
            ;;
        *)
            error "Your distribution is undefined."
            ;;
    esac
}
function dryrun(){
    echo -e "${PURPLE}DRYRUN:${CLEAR} $@"
}
function run(){
    if [[ "${DRYRUN:-}" == "" ]];then
        "$@"
    else
        {
            dryrun "$@"
        }
    fi
}
function yes_no(){
    local ans
    echo -n "$1"
    read ans
    case "$ans" in
        [Yy]*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
function helpmsg(){
echo -e "Usage: ${BASH_SOURCE[0]:-$0} [option] ... [--help | -h]
Options:
    -h, --help         Show this message
    -d, --debug        Enable command trace
    --dryrun           Enable dry run"
}

function main(){
    ################# Argument Parser ###############
    while [ $# -gt 0 ];do
        case ${1} in
            --help|-h)
                helpmsg
                exit 1
                ;;
            --debug|-d)
                set -uex
                ;;
            --dryrun)
                DRYRUN=true
                ;;
           *)
                ;;
        esac
        shift
    done
    
    if ! yes_no "Start setup.OK? [Y/n] ";then
        exit 1
    fi
    echo
    ################# Main Procedure ################
    #---------------- Keymap setting ----------------
    title "Keymap setting"
    title "================================"
    # capslock -> ctrl
    run sudo localectl set-x11-keymap jp pc105 "" ctrl:nocaps
    if [[ $? -eq 0 ]];then
        success "key change 'capslock' to 'ctrl'"
    else
        error "key change 'capslock' to 'ctrl'"
    fi
    echo
    #---------------- Application Install ---------------------
    title "Application Install"
    title "================================"
    run checkinstall git tmux gcc binutils make cmake vim deno starship
    # tmux:tpm
    if [[ ! -d "$HOME"/.tmux/plugins/tpm ]];then
        run git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm &> /dev/null
        if [[ "$?" -eq 0 ]];then
            success "'tpm' is cloned to ${HOME}/.tmux/plugins/tpm"
        else
            error "'tpm' is cloned"
        fi
    else
        warning "'tpm' is already installed to ${HOME}/.tmux/plugins/tpm"
    fi
    echo
    #---------------- Utils -------------------------
    title "Utils"
    title "================================"
    # bluetooth
    run sudo systemctl start bluetooth.service
    run sudo systemctl enable bluetooth.service
    if [[ $? -eq 0 ]];then
        success "enable bluetooth.service"
    else
        error "disable bluetooth.service"
    fi
    echo
    #---------------- Create symlinks -------------------------
    title "Create symlinks"
    title "================================"
    local currentdir=$(dirname $(readlink -f "${BASH_SOURCE[0]:-$0}"))
    run symlink "$currentdir"/.vimrc "$HOME"/.vimrc
    run dirlink "$currentdir" "$HOME"/.vim
    run mymkdir "$HOME"/.vim/.undo
    run symlink "$currentdir"/.bashrc "$HOME"/.bashrc
    run symlink "$currentdir"/.inputrc "$HOME"/.inputrc
    run symlink "$currentdir"/.tmux.conf "$HOME"/.tmux.conf
    run mymkdir "$HOME"/.config/powerline-shell
    run mymkdir "$HOME"/.config/starship
    run symlink "$currentdir"/config/powerline-shell/config.json "$HOME"/.config/powerline-shell/config.json
    run symlink "$currentdir"/config/starship/starship.toml "$HOME"/.config/starship/starship.toml
    echo

    title "done"
}

main "$@"
