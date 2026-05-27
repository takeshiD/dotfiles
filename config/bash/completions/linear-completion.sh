#!/usr/bin/env bash
# bash completion support for linear v2.0.0

_linear() {
  local word cur prev listFiles
  local -a opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  cmd="_"
  opts=()
  listFiles=0

  _linear_complete() {
    local action="$1"; shift
    mapfile -t values < <( linear completions complete "${action}" "${@}" )
    for i in "${values[@]}"; do
      opts+=("$i")
    done
  }

  _linear_expand() {
    [ "$cur" != "${cur%\\}" ] && cur="$cur\\"
  
    # expand ~username type directory specifications
    if [[ "$cur" == \~*/* ]]; then
      # shellcheck disable=SC2086
      eval cur=$cur
      
    elif [[ "$cur" == \~* ]]; then
      cur=${cur#\~}
      # shellcheck disable=SC2086,SC2207
      COMPREPLY=( $( compgen -P '~' -u $cur ) )
      return ${#COMPREPLY[@]}
    fi
  }

  # shellcheck disable=SC2120
  _linear_file_dir() {
    listFiles=1
    local IFS=$'\t\n' xspec #glob
    _linear_expand || return 0
  
    if [ "${1:-}" = -d ]; then
      # shellcheck disable=SC2206,SC2207,SC2086
      COMPREPLY=( ${COMPREPLY[@]:-} $( compgen -d -- $cur ) )
      #eval "$glob"    # restore glob setting.
      return 0
    fi
  
    xspec=${1:+"!*.$1"}	# set only if glob passed in as $1
    # shellcheck disable=SC2206,SC2207
    COMPREPLY=( ${COMPREPLY[@]:-} $( compgen -f -X "$xspec" -- "$cur" )           $( compgen -d -- "$cur" ) )
  }

  __linear() {
    opts=(-h --help -V --version --workspace auth issue team project project-update cycle milestone initiative initiative-update label document completions config schema api)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      -V|--version) opts=() ;;
      --workspace) opts=(); _linear_complete string ;;
    esac
  }

  __linear_auth() {
    opts=(-h --help --workspace login logout list default token whoami migrate)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth ;;
    esac
  }

  __linear_auth_login() {
    opts=(-h --help --workspace -k --key --plaintext)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth login ;;
      -k|--key) opts=(); _linear_complete string auth login ;;
      --plaintext)  ;;
    esac
  }

  __linear_auth_logout() {
    opts=(-h --help --workspace -f --force)
    _linear_complete string auth logout
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth logout ;;
      -f|--force)  ;;
    esac
  }

  __linear_auth_list() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth list ;;
    esac
  }

  __linear_auth_default() {
    opts=(-h --help --workspace)
    _linear_complete string auth default
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth default ;;
    esac
  }

  __linear_auth_token() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth token ;;
    esac
  }

  __linear_auth_whoami() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth whoami ;;
    esac
  }

  __linear_auth_migrate() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string auth migrate ;;
    esac
  }

  __linear_issue() {
    opts=(-h --help --workspace id mine query title start view url describe commits pull-request delete create update comment attach link relation agent-session)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue ;;
    esac
  }

  __linear_issue_id() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue id ;;
    esac
  }

  __linear_issue_mine() {
    opts=(-h --help --workspace -s --state --all-states --sort --team --project --project-label --cycle --milestone -l --label --limit --created-after --updated-after -w --web -a --app --no-pager)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue mine ;;
      -s|--state) opts=(); _linear_complete state issue mine ;;
      --all-states)  ;;
      --sort) opts=(); _linear_complete sort issue mine ;;
      --team) opts=(); _linear_complete string issue mine ;;
      --project) opts=(); _linear_complete string issue mine ;;
      --project-label) opts=(); _linear_complete string issue mine ;;
      --cycle) opts=(); _linear_complete string issue mine ;;
      --milestone) opts=(); _linear_complete string issue mine ;;
      -l|--label) opts=(); _linear_complete string issue mine ;;
      --limit) opts=(); _linear_complete number issue mine ;;
      --created-after) opts=(); _linear_complete string issue mine ;;
      --updated-after) opts=(); _linear_complete string issue mine ;;
      -w|--web)  ;;
      -a|--app)  ;;
      --no-pager)  ;;
    esac
  }

  __linear_issue_query() {
    opts=(-h --help --workspace --search --search-comments --team --all-teams -s --state --all-states --assignee -A --all-assignees -U --unassigned --sort --project --project-label --cycle --milestone -l --label --limit --created-after --updated-after --include-archived -j --json --no-pager)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue query ;;
      --search) opts=(); _linear_complete string issue query ;;
      --search-comments)  ;;
      --team) opts=(); _linear_complete string issue query ;;
      --all-teams)  ;;
      -s|--state) opts=(); _linear_complete state issue query ;;
      --all-states)  ;;
      --assignee) opts=(); _linear_complete string issue query ;;
      -A|--all-assignees)  ;;
      -U|--unassigned)  ;;
      --sort) opts=(); _linear_complete sort issue query ;;
      --project) opts=(); _linear_complete string issue query ;;
      --project-label) opts=(); _linear_complete string issue query ;;
      --cycle) opts=(); _linear_complete string issue query ;;
      --milestone) opts=(); _linear_complete string issue query ;;
      -l|--label) opts=(); _linear_complete string issue query ;;
      --limit) opts=(); _linear_complete number issue query ;;
      --created-after) opts=(); _linear_complete string issue query ;;
      --updated-after) opts=(); _linear_complete string issue query ;;
      --include-archived)  ;;
      -j|--json)  ;;
      --no-pager)  ;;
    esac
  }

  __linear_issue_title() {
    opts=(-h --help --workspace)
    _linear_complete string issue title
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue title ;;
    esac
  }

  __linear_issue_start() {
    opts=(-h --help --workspace -A --all-assignees -U --unassigned -f --from-ref -b --branch)
    _linear_complete string issue start
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue start ;;
      -A|--all-assignees)  ;;
      -U|--unassigned)  ;;
      -f|--from-ref) opts=(); _linear_complete string issue start ;;
      -b|--branch) opts=(); _linear_complete string issue start ;;
    esac
  }

  __linear_issue_view() {
    opts=(-h --help --workspace -w --web -a --app --no-comments --show-resolved-threads --no-pager -j --json --no-download)
    _linear_complete string issue view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue view ;;
      -w|--web)  ;;
      -a|--app)  ;;
      --no-comments)  ;;
      --show-resolved-threads)  ;;
      --no-pager)  ;;
      -j|--json)  ;;
      --no-download)  ;;
    esac
  }

  __linear_issue_url() {
    opts=(-h --help --workspace)
    _linear_complete string issue url
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue url ;;
    esac
  }

  __linear_issue_describe() {
    opts=(-h --help --workspace -r --references --ref)
    _linear_complete string issue describe
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue describe ;;
      -r|--references|--ref)  ;;
    esac
  }

  __linear_issue_commits() {
    opts=(-h --help --workspace)
    _linear_complete string issue commits
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue commits ;;
    esac
  }

  __linear_issue_pull_request() {
    opts=(-h --help --workspace --base --draft -t --title --web --head)
    _linear_complete string issue pull-request
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue pull-request ;;
      --base) opts=(); _linear_complete string issue pull-request ;;
      --draft)  ;;
      -t|--title) opts=(); _linear_complete string issue pull-request ;;
      --web)  ;;
      --head) opts=(); _linear_complete string issue pull-request ;;
    esac
  }

  __linear_issue_delete() {
    opts=(-h --help --workspace -y --confirm --bulk --bulk-file --bulk-stdin)
    _linear_complete string issue delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue delete ;;
      -y|--confirm)  ;;
      --bulk) opts=(); _linear_complete string issue delete ;;
      --bulk-file) opts=(); _linear_complete string issue delete ;;
      --bulk-stdin)  ;;
    esac
  }

  __linear_issue_create() {
    opts=(-h --help --workspace --start -a --assignee --due-date --parent -p --priority --estimate -d --description --description-file -l --label --team --project -s --state --milestone --cycle --no-use-default-template --no-interactive -t --title)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue create ;;
      --start)  ;;
      -a|--assignee) opts=(); _linear_complete string issue create ;;
      --due-date) opts=(); _linear_complete string issue create ;;
      --parent) opts=(); _linear_complete string issue create ;;
      -p|--priority) opts=(); _linear_complete number issue create ;;
      --estimate) opts=(); _linear_complete number issue create ;;
      -d|--description) opts=(); _linear_complete string issue create ;;
      --description-file) opts=(); _linear_complete string issue create ;;
      -l|--label) opts=(); _linear_complete string issue create ;;
      --team) opts=(); _linear_complete string issue create ;;
      --project) opts=(); _linear_complete string issue create ;;
      -s|--state) opts=(); _linear_complete string issue create ;;
      --milestone) opts=(); _linear_complete string issue create ;;
      --cycle) opts=(); _linear_complete string issue create ;;
      --no-use-default-template)  ;;
      --no-interactive)  ;;
      -t|--title) opts=(); _linear_complete string issue create ;;
    esac
  }

  __linear_issue_update() {
    opts=(-h --help --workspace -a --assignee --due-date --parent -p --priority --estimate -d --description --description-file -l --label --team --project -s --state --milestone --cycle -t --title)
    _linear_complete string issue update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue update ;;
      -a|--assignee) opts=(); _linear_complete string issue update ;;
      --due-date) opts=(); _linear_complete string issue update ;;
      --parent) opts=(); _linear_complete string issue update ;;
      -p|--priority) opts=(); _linear_complete number issue update ;;
      --estimate) opts=(); _linear_complete number issue update ;;
      -d|--description) opts=(); _linear_complete string issue update ;;
      --description-file) opts=(); _linear_complete string issue update ;;
      -l|--label) opts=(); _linear_complete string issue update ;;
      --team) opts=(); _linear_complete string issue update ;;
      --project) opts=(); _linear_complete string issue update ;;
      -s|--state) opts=(); _linear_complete string issue update ;;
      --milestone) opts=(); _linear_complete string issue update ;;
      --cycle) opts=(); _linear_complete string issue update ;;
      -t|--title) opts=(); _linear_complete string issue update ;;
    esac
  }

  __linear_issue_comment() {
    opts=(-h --help --workspace add delete update list)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue comment ;;
    esac
  }

  __linear_issue_comment_add() {
    opts=(-h --help --workspace -b --body --body-file -p --parent -a --attach)
    _linear_complete string issue comment add
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue comment add ;;
      -b|--body) opts=(); _linear_complete string issue comment add ;;
      --body-file) opts=(); _linear_complete string issue comment add ;;
      -p|--parent) opts=(); _linear_complete string issue comment add ;;
      -a|--attach) opts=(); _linear_complete string issue comment add ;;
    esac
  }

  __linear_issue_comment_delete() {
    opts=(-h --help --workspace)
    _linear_complete string issue comment delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue comment delete ;;
    esac
  }

  __linear_issue_comment_update() {
    opts=(-h --help --workspace -b --body --body-file)
    _linear_complete string issue comment update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue comment update ;;
      -b|--body) opts=(); _linear_complete string issue comment update ;;
      --body-file) opts=(); _linear_complete string issue comment update ;;
    esac
  }

  __linear_issue_comment_list() {
    opts=(-h --help --workspace -j --json)
    _linear_complete string issue comment list
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue comment list ;;
      -j|--json)  ;;
    esac
  }

  __linear_issue_attach() {
    opts=(-h --help --workspace -t --title -c --comment)
    _linear_complete string issue attach
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue attach ;;
      -t|--title) opts=(); _linear_complete string issue attach ;;
      -c|--comment) opts=(); _linear_complete string issue attach ;;
    esac
  }

  __linear_issue_link() {
    opts=(-h --help --workspace -t --title)
    _linear_complete string issue link
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue link ;;
      -t|--title) opts=(); _linear_complete string issue link ;;
    esac
  }

  __linear_issue_relation() {
    opts=(-h --help --workspace add delete list)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue relation ;;
    esac
  }

  __linear_issue_relation_add() {
    opts=(-h --help --workspace)
    _linear_complete string issue relation add
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue relation add ;;
    esac
  }

  __linear_issue_relation_delete() {
    opts=(-h --help --workspace)
    _linear_complete string issue relation delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue relation delete ;;
    esac
  }

  __linear_issue_relation_list() {
    opts=(-h --help --workspace)
    _linear_complete string issue relation list
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue relation list ;;
    esac
  }

  __linear_issue_agent_session() {
    opts=(-h --help --workspace list view)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue agent-session ;;
    esac
  }

  __linear_issue_agent_session_list() {
    opts=(-h --help --workspace -j --json --status)
    _linear_complete string issue agent-session list
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue agent-session list ;;
      -j|--json)  ;;
      --status) opts=(); _linear_complete agentSessionStatus issue agent-session list ;;
    esac
  }

  __linear_issue_agent_session_view() {
    opts=(-h --help --workspace -j --json)
    _linear_complete string issue agent-session view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string issue agent-session view ;;
      -j|--json)  ;;
    esac
  }

  __linear_team() {
    opts=(-h --help --workspace create delete list id autolinks members)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team ;;
    esac
  }

  __linear_team_create() {
    opts=(-h --help --workspace -n --name -d --description -k --key --private --no-interactive)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team create ;;
      -n|--name) opts=(); _linear_complete string team create ;;
      -d|--description) opts=(); _linear_complete string team create ;;
      -k|--key) opts=(); _linear_complete string team create ;;
      --private)  ;;
      --no-interactive)  ;;
    esac
  }

  __linear_team_delete() {
    opts=(-h --help --workspace --move-issues -y --force)
    _linear_complete string team delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team delete ;;
      --move-issues) opts=(); _linear_complete string team delete ;;
      -y|--force)  ;;
    esac
  }

  __linear_team_list() {
    opts=(-h --help --workspace -w --web -a --app)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team list ;;
      -w|--web)  ;;
      -a|--app)  ;;
    esac
  }

  __linear_team_id() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team id ;;
    esac
  }

  __linear_team_autolinks() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team autolinks ;;
    esac
  }

  __linear_team_members() {
    opts=(-h --help --workspace -a --all)
    _linear_complete string team members
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string team members ;;
      -a|--all)  ;;
    esac
  }

  __linear_project() {
    opts=(-h --help --workspace list view create update delete)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project ;;
    esac
  }

  __linear_project_list() {
    opts=(-h --help --workspace --team --all-teams --status -w --web -a --app -j --json)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project list ;;
      --team) opts=(); _linear_complete string project list ;;
      --all-teams)  ;;
      --status) opts=(); _linear_complete string project list ;;
      -w|--web)  ;;
      -a|--app)  ;;
      -j|--json)  ;;
    esac
  }

  __linear_project_view() {
    opts=(-h --help --workspace -w --web -a --app)
    _linear_complete string project view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project view ;;
      -w|--web)  ;;
      -a|--app)  ;;
    esac
  }

  __linear_project_create() {
    opts=(-h --help --workspace -n --name -d --description -t --team -l --lead -s --status --start-date --target-date --initiative -i --interactive -j --json)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project create ;;
      -n|--name) opts=(); _linear_complete string project create ;;
      -d|--description) opts=(); _linear_complete string project create ;;
      -t|--team) opts=(); _linear_complete string project create ;;
      -l|--lead) opts=(); _linear_complete string project create ;;
      -s|--status) opts=(); _linear_complete string project create ;;
      --start-date) opts=(); _linear_complete string project create ;;
      --target-date) opts=(); _linear_complete string project create ;;
      --initiative) opts=(); _linear_complete string project create ;;
      -i|--interactive)  ;;
      -j|--json)  ;;
    esac
  }

  __linear_project_update() {
    opts=(-h --help --workspace -n --name -d --description -s --status -l --lead --start-date --target-date -t --team)
    _linear_complete string project update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project update ;;
      -n|--name) opts=(); _linear_complete string project update ;;
      -d|--description) opts=(); _linear_complete string project update ;;
      -s|--status) opts=(); _linear_complete string project update ;;
      -l|--lead) opts=(); _linear_complete string project update ;;
      --start-date) opts=(); _linear_complete string project update ;;
      --target-date) opts=(); _linear_complete string project update ;;
      -t|--team) opts=(); _linear_complete string project update ;;
    esac
  }

  __linear_project_delete() {
    opts=(-h --help --workspace -f --force)
    _linear_complete string project delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project delete ;;
      -f|--force)  ;;
    esac
  }

  __linear_project_update() {
    opts=(-h --help --workspace create list)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project-update ;;
    esac
  }

  __linear_project_update_create() {
    opts=(-h --help --workspace --body --body-file --health -i --interactive)
    _linear_complete string project-update create
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project-update create ;;
      --body) opts=(); _linear_complete string project-update create ;;
      --body-file) opts=(); _linear_complete string project-update create ;;
      --health) opts=(); _linear_complete string project-update create ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_project_update_list() {
    opts=(-h --help --workspace --json --limit)
    _linear_complete string project-update list
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string project-update list ;;
      --json)  ;;
      --limit) opts=(); _linear_complete number project-update list ;;
    esac
  }

  __linear_cycle() {
    opts=(-h --help --workspace list view)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string cycle ;;
    esac
  }

  __linear_cycle_list() {
    opts=(-h --help --workspace --team)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string cycle list ;;
      --team) opts=(); _linear_complete string cycle list ;;
    esac
  }

  __linear_cycle_view() {
    opts=(-h --help --workspace --team)
    _linear_complete string cycle view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string cycle view ;;
      --team) opts=(); _linear_complete string cycle view ;;
    esac
  }

  __linear_milestone() {
    opts=(-h --help --workspace list view create update delete)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone ;;
    esac
  }

  __linear_milestone_list() {
    opts=(-h --help --workspace --project)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone list ;;
      --project) opts=(); _linear_complete string milestone list ;;
    esac
  }

  __linear_milestone_view() {
    opts=(-h --help --workspace)
    _linear_complete string milestone view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone view ;;
    esac
  }

  __linear_milestone_create() {
    opts=(-h --help --workspace --project --name --description --target-date)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone create ;;
      --project) opts=(); _linear_complete string milestone create ;;
      --name) opts=(); _linear_complete string milestone create ;;
      --description) opts=(); _linear_complete string milestone create ;;
      --target-date) opts=(); _linear_complete string milestone create ;;
    esac
  }

  __linear_milestone_update() {
    opts=(-h --help --workspace --name --description --target-date --sort-order --project)
    _linear_complete string milestone update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone update ;;
      --name) opts=(); _linear_complete string milestone update ;;
      --description) opts=(); _linear_complete string milestone update ;;
      --target-date) opts=(); _linear_complete string milestone update ;;
      --sort-order) opts=(); _linear_complete number milestone update ;;
      --project) opts=(); _linear_complete string milestone update ;;
    esac
  }

  __linear_milestone_delete() {
    opts=(-h --help --workspace -f --force)
    _linear_complete string milestone delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string milestone delete ;;
      -f|--force)  ;;
    esac
  }

  __linear_initiative() {
    opts=(-h --help --workspace list view create archive update unarchive delete add-project remove-project)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative ;;
    esac
  }

  __linear_initiative_list() {
    opts=(-h --help --workspace -s --status --all-statuses -o --owner -w --web -a --app -j --json --archived)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative list ;;
      -s|--status) opts=(); _linear_complete string initiative list ;;
      --all-statuses)  ;;
      -o|--owner) opts=(); _linear_complete string initiative list ;;
      -w|--web)  ;;
      -a|--app)  ;;
      -j|--json)  ;;
      --archived)  ;;
    esac
  }

  __linear_initiative_view() {
    opts=(-h --help --workspace -w --web -a --app -j --json)
    _linear_complete string initiative view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative view ;;
      -w|--web)  ;;
      -a|--app)  ;;
      -j|--json)  ;;
    esac
  }

  __linear_initiative_create() {
    opts=(-h --help --workspace -n --name -d --description -s --status -o --owner --target-date -c --color --icon -i --interactive)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative create ;;
      -n|--name) opts=(); _linear_complete string initiative create ;;
      -d|--description) opts=(); _linear_complete string initiative create ;;
      -s|--status) opts=(); _linear_complete string initiative create ;;
      -o|--owner) opts=(); _linear_complete string initiative create ;;
      --target-date) opts=(); _linear_complete string initiative create ;;
      -c|--color) opts=(); _linear_complete string initiative create ;;
      --icon) opts=(); _linear_complete string initiative create ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_initiative_archive() {
    opts=(-h --help --workspace -y --force --bulk --bulk-file --bulk-stdin)
    _linear_complete string initiative archive
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative archive ;;
      -y|--force)  ;;
      --bulk) opts=(); _linear_complete string initiative archive ;;
      --bulk-file) opts=(); _linear_complete string initiative archive ;;
      --bulk-stdin)  ;;
    esac
  }

  __linear_initiative_update() {
    opts=(-h --help --workspace -n --name -d --description --status --owner --target-date --color --icon -i --interactive)
    _linear_complete string initiative update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative update ;;
      -n|--name) opts=(); _linear_complete string initiative update ;;
      -d|--description) opts=(); _linear_complete string initiative update ;;
      --status) opts=(); _linear_complete string initiative update ;;
      --owner) opts=(); _linear_complete string initiative update ;;
      --target-date) opts=(); _linear_complete string initiative update ;;
      --color) opts=(); _linear_complete string initiative update ;;
      --icon) opts=(); _linear_complete string initiative update ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_initiative_unarchive() {
    opts=(-h --help --workspace -y --force)
    _linear_complete string initiative unarchive
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative unarchive ;;
      -y|--force)  ;;
    esac
  }

  __linear_initiative_delete() {
    opts=(-h --help --workspace -y --force --bulk --bulk-file --bulk-stdin)
    _linear_complete string initiative delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative delete ;;
      -y|--force)  ;;
      --bulk) opts=(); _linear_complete string initiative delete ;;
      --bulk-file) opts=(); _linear_complete string initiative delete ;;
      --bulk-stdin)  ;;
    esac
  }

  __linear_initiative_add_project() {
    opts=(-h --help --workspace --sort-order)
    _linear_complete string initiative add-project
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative add-project ;;
      --sort-order) opts=(); _linear_complete number initiative add-project ;;
    esac
  }

  __linear_initiative_remove_project() {
    opts=(-h --help --workspace -y --force)
    _linear_complete string initiative remove-project
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative remove-project ;;
      -y|--force)  ;;
    esac
  }

  __linear_initiative_update() {
    opts=(-h --help --workspace create list)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative-update ;;
    esac
  }

  __linear_initiative_update_create() {
    opts=(-h --help --workspace --body --body-file --health -i --interactive)
    _linear_complete string initiative-update create
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative-update create ;;
      --body) opts=(); _linear_complete string initiative-update create ;;
      --body-file) opts=(); _linear_complete string initiative-update create ;;
      --health) opts=(); _linear_complete string initiative-update create ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_initiative_update_list() {
    opts=(-h --help --workspace -j --json --limit)
    _linear_complete string initiative-update list
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string initiative-update list ;;
      -j|--json)  ;;
      --limit) opts=(); _linear_complete number initiative-update list ;;
    esac
  }

  __linear_label() {
    opts=(-h --help --workspace list create delete)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string label ;;
    esac
  }

  __linear_label_list() {
    opts=(-h --help --team --workspace --all -j --json)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --team) opts=(); _linear_complete string label list ;;
      --workspace)  ;;
      --all)  ;;
      -j|--json)  ;;
    esac
  }

  __linear_label_create() {
    opts=(-h --help --workspace -n --name -c --color -d --description -t --team -i --interactive)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string label create ;;
      -n|--name) opts=(); _linear_complete string label create ;;
      -c|--color) opts=(); _linear_complete string label create ;;
      -d|--description) opts=(); _linear_complete string label create ;;
      -t|--team) opts=(); _linear_complete string label create ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_label_delete() {
    opts=(-h --help --workspace -t --team -f --force)
    _linear_complete string label delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string label delete ;;
      -t|--team) opts=(); _linear_complete string label delete ;;
      -f|--force)  ;;
    esac
  }

  __linear_document() {
    opts=(-h --help --workspace list view create update delete)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document ;;
    esac
  }

  __linear_document_list() {
    opts=(-h --help --workspace --project --issue --json --limit)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document list ;;
      --project) opts=(); _linear_complete string document list ;;
      --issue) opts=(); _linear_complete string document list ;;
      --json)  ;;
      --limit) opts=(); _linear_complete number document list ;;
    esac
  }

  __linear_document_view() {
    opts=(-h --help --workspace --raw -w --web --json)
    _linear_complete string document view
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document view ;;
      --raw)  ;;
      -w|--web)  ;;
      --json)  ;;
    esac
  }

  __linear_document_create() {
    opts=(-h --help --workspace -t --title -c --content -f --content-file --project --issue --icon -i --interactive)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document create ;;
      -t|--title) opts=(); _linear_complete string document create ;;
      -c|--content) opts=(); _linear_complete string document create ;;
      -f|--content-file) opts=(); _linear_complete string document create ;;
      --project) opts=(); _linear_complete string document create ;;
      --issue) opts=(); _linear_complete string document create ;;
      --icon) opts=(); _linear_complete string document create ;;
      -i|--interactive)  ;;
    esac
  }

  __linear_document_update() {
    opts=(-h --help --workspace -t --title -c --content -f --content-file --icon -e --edit)
    _linear_complete string document update
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document update ;;
      -t|--title) opts=(); _linear_complete string document update ;;
      -c|--content) opts=(); _linear_complete string document update ;;
      -f|--content-file) opts=(); _linear_complete string document update ;;
      --icon) opts=(); _linear_complete string document update ;;
      -e|--edit)  ;;
    esac
  }

  __linear_document_delete() {
    opts=(-h --help --workspace -y --yes --bulk --bulk-file --bulk-stdin)
    _linear_complete string document delete
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string document delete ;;
      -y|--yes)  ;;
      --bulk) opts=(); _linear_complete string document delete ;;
      --bulk-file) opts=(); _linear_complete string document delete ;;
      --bulk-stdin)  ;;
    esac
  }

  __linear_completions() {
    opts=(-h --help bash fish zsh)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
    esac
  }

  __linear_completions_bash() {
    opts=(-h --help -n --name)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      -n|--name) opts=(); _linear_complete string completions bash ;;
    esac
  }

  __linear_completions_fish() {
    opts=(-h --help -n --name)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      -n|--name) opts=(); _linear_complete string completions fish ;;
    esac
  }

  __linear_completions_zsh() {
    opts=(-h --help -n --name)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      -n|--name) opts=(); _linear_complete string completions zsh ;;
    esac
  }

  __linear_config() {
    opts=(-h --help --workspace)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string config ;;
    esac
  }

  __linear_schema() {
    opts=(-h --help --workspace --json -o --output)
    
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string schema ;;
      --json)  ;;
      -o|--output) opts=(); _linear_complete string schema ;;
    esac
  }

  __linear_api() {
    opts=(-h --help --workspace --variable --variables-json --paginate --silent)
    _linear_complete string api
    if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
      return 0
    fi
    case "${prev}" in
      -h|--help) opts=() ;;
      --workspace) opts=(); _linear_complete string api ;;
      --variable) opts=(); _linear_complete variable api ;;
      --variables-json) opts=(); _linear_complete string api ;;
      --paginate)  ;;
      --silent)  ;;
    esac
  }

  for word in "${COMP_WORDS[@]}"; do
    case "${word}" in
      -*) ;;
      *)
        cmd_tmp="${cmd}_${word//[^[:alnum:]]/_}"
        if type "${cmd_tmp}" &>/dev/null; then
          cmd="${cmd_tmp}"
        fi
    esac
  done

  ${cmd}

  if [[ listFiles -eq 1 ]]; then
    return 0
  fi

  if [[ ${#opts[@]} -eq 0 ]]; then
    # shellcheck disable=SC2207
    COMPREPLY=($(compgen -f "${cur}"))
    return 0
  fi

  local values
  values="$( printf "\n%s" "${opts[@]}" )"
  local IFS=$'\n'
  # shellcheck disable=SC2207
  local result=($(compgen -W "${values[@]}" -- "${cur}"))
  if [[ ${#result[@]} -eq 0 ]]; then
    # shellcheck disable=SC2207
    COMPREPLY=($(compgen -f "${cur}"))
  else
    # shellcheck disable=SC2207
    COMPREPLY=($(printf '%q\n' "${result[@]}"))
  fi

  return 0
}

complete -F _linear -o bashdefault -o default linear
