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
    echo -e "${GREEN}${BOLD}[OKAY]${CLEAR} ${1}"
}
function warning(){
    echo -e "${YELLOW}${BOLD}[WARN]${CLEAR} ${1}"
}
function error(){
    echo -e "${RED}${BOLD}[FAIL]${CLEAR} ${1}"
}
function info(){
    echo -e "${BLUE}${BOLD}[INFO]${CLEAR} ${1}"
}
function title(){
    echo -e "${BOLD}${WHITE}$1${CLEAR}"
}
