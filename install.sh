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
BOLD='\e[1m'

function success(){
    echo -e "${GREEN}${BOLD}SUCCESS:${CLEAR} ${1}"
}
function warning(){
    echo -e "${YELLOW}${BOLD}WARNING:${CLEAR} ${1}"
}
function error(){
    echo -e "${RED}${BOLD}ERROR:${CLEAR} ${1}"
}
function info(){
    echo -e "${BLUE}${BOLD}INFO:${CLEAR} ${1}"
}
function title(){
    echo -e "${BOLD}${WHITE}$1${CLEAR}"
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
    _create_link -sfbn "$1" "$2"
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
            alias pkgmng='apt -y install'
            sudo apt update
            sudo apt upgrade
            ;;
        arch)
            alias pkgmng='pacman -S --noconfirm --needed'
            sudo pacman -Syy
            sudo pacman -Syyu
            ;;
        *)
            error "Your distribution is undefined."
            exit 1
            ;;
    esac
    for pkg in $pkgs
    do
        # which $pkg &> /dev/null
        # ret=$?
        if [[ -x $(which $pkg) ]];then
            info "Already installed: $pkg"
            continue;
        fi
        sudo pkgmng $pkg &> /dev/null
        ret=$?
        if [[ $ret -eq 0 ]];then
            success "installed '$pkg'"
        else
            warning "install failed '$pkg'"
        fi
    done
    unalias pkgmng
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

function is_exist_service(){
    local service="$1"
    systemctl list-unit-files -t service | grep "$service"
    return "$?"
}

function is_wls(){
    case "$(uname -r)" in
        *microsoft* ) return 0;;
        *Microsoft* ) return 0;;
        * ) return 1;;
    esac
}

function main(){
    ################# Argument Parser ###############
    while [[ "$#" -gt 0 ]];do
        case "$1" in
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
            --)
                shift
                break
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
    
    if ! yes_no "Start setup? [Y/n] ";then
        exit 1
    fi
    echo
    ################# Main Procedure ################
    #---------------- Keymap setting ----------------
    title "Keymap setting"
    title "================================"
    # capslock -> ctrl
    if is_wls; then
    info "This current system is running on WLS. keymap setting is skipped"
    else
    run sudo localectl set-x11-keymap jp pc105 "" ctrl:nocaps
    if [[ $? -eq 0 ]];then
        success "key change 'capslock' to 'ctrl'"
    else
        error "key change 'capslock' to 'ctrl'"
    fi
    fi
    echo
    #---------------- Application Install ---------------------
    echo
    title "Application Install"
    title "================================"
    set +e
    run checkinstall zip less git tmux gcc binutils make cmake vim neovim powerline acpi clangd skktools fzf ripgrep ruby trans rlwrapp pkg-config
    set -e
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
    echo
    title "Utils"
    title "================================"
    # bluetooth
    if is_wls; then
        info "This current system is running on WLS. bluetooth setting is skipped"
    else
        if is_exist_service "bluetooth";then
           run sudo systemctl start bluetooth.service
           run sudo systemctl enable bluetooth.service
           if [[ $? -eq 0 ]];then
               success "enable 'bluetooth.service'"
           else
               error "disable 'bluetooth.service'"
           fi
           echo
        else
            warning "'bluetooth.service is not running on systemd.'"
        fi
    fi
    if [[ -x $(which rustup) ]]; then
        info "Already installed rustup"
    else
        run curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        if [[ $? -eq 0 ]];then
            success "installed rustup"
        else
            error "install failed rustup"
        fi
    fi
    if [[ -x $(which starship) ]]; then
        info "Already installed starship"
    else
        run cargo install starship --locked &> /dev/null
        if [[ $? -eq 0 ]]; then
    	success "installed starship"
        else
    	error "install failed starship"
        fi
    fi
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        info "Already installed nvm"
    else
        run curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        if [[ $? -eq 0 ]]; then
            success "installed nvm"
        else
            error "install failed nvm"
        fi
    fi
    # deno latest: install to ~/.deno/bin
    if [[ -x $(which deno) ]]; then
        info "Already installed deno"
    else
        run curl -fsSL https://deno.land/install.sh | sh
        if [[ $? -eq 0 ]];then
            success "installed deno"
        else
            error "install failed deno"
        fi
    fi
    #---------------- Create symlinks -------------------------
    echo
    title "Create symlinks"
    title "================================"
    local currentdir=$(dirname $(readlink -f "${BASH_SOURCE[0]:-$0}"))
    run mymkdir "$HOME"/.vim/.undo
    run mymkdir "$HOME"/.nvim/.undo
    run mymkdir "$HOME"/.config/powerline-shell
    run mymkdir "$HOME"/.config/starship
    run mymkdir "$HOME"/.config/wezterm
    run mymkdir "$HOME"/.config/nvim
    run mymkdir "$HOME"/.tmux/resurrect
    run mymkdir "$HOME"/.local

    run symlink "$currentdir"/config/vim/.vimrc "$HOME"/.vimrc
    run symlink "$currentdir"/config/nvim/init.vim "$HOME"/.config/nvim/init.vim
    run symlink "$currentdir"/.bashrc "$HOME"/.bashrc
    run symlink "$currentdir"/.inputrc "$HOME"/.inputrc
    run symlink "$currentdir"/.tmux.conf "$HOME"/.tmux.conf
    run symlink "$currentdir"/config/powerline-shell/config.json "$HOME"/.config/powerline-shell/config.json
    run symlink "$currentdir"/config/starship/starship.toml "$HOME"/.config/starship/starship.toml
    run dirlink "$currentdir"/skk "$HOME"/.skk
    run dirlink "$currentdir"/clangd "$HOME"/.local/clangd
    run dirlink "$currentdir"/memo "$HOME"/memo
    run symlink "$currentdir"/config/wezterm/wezterm.lua "$HOME"/.config/wezterm/wezterm.lua
    run symlink "$currentdir"/config/vim/dein.toml "$HOME"/.vim/dein.toml
    run symlink "$currentdir"/config/nvim/init.lua "$HOME"/.config/nvim/init.lua
    run symlink "$currentdir"/config/nvim/lazy-lock.json "$HOME"/.config/nvim/lazy-lock.json
    run dirlink "$currentdir"/config/nvim/lua "$HOME"/.config/nvim/lua
    run cp "$currentdir"/.gitconfig "$HOME"/.gitconfig
    # run git config --global credential.helper store --file ~/.git-credentials
    title "done"
}

main "$@"
