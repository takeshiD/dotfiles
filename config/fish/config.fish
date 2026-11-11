#=======================================================
# zoxide
#=======================================================
if command -v zoxide &> /dev/null
    zoxide init fish --cmd j | source
end

#=======================================================
# starship
#=======================================================
if command -v starship &> /dev/null
    starship init fish | source
end

#=======================================================
# direnv
#=======================================================
if command -v direnv &> /dev/null
    direnv hook fish | source
end

if type -q aws_completer
	function __aws_completer
		set -lx COMP_LINE (commandline -pc)
		set -lx COMP_POINT (string length $COMP_LINE)
		aws_completer | tr -d ' '
	end

	complete -c awsr -f -a "(__aws_completer)"
end
