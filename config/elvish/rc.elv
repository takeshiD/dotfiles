eval (starship init elvish)
# use readline-binding
set edit:global-binding[Ctrl-G] = $edit:close-mode~

# Operating
set edit:insert:binding[Ctrl-H] = $edit:move-dot-sol~
set edit:insert:binding[Ctrl-L] = $edit:move-dot-eol~

# ------ History -------
## Entering History-mode
set edit:insert:binding[Ctrl-P] = $edit:history:start~
set edit:insert:binding[Ctrl-N] = $edit:history:start~

## Operations in History mode
set edit:history:binding[Ctrl-P] = $edit:history:up~
set edit:history:binding[Ctrl-N] = $edit:history:down-or-quit~
set edit:history:binding[Enter] = $edit:history:accept~

# set edit:insert:binding[Tab] = $edit:histlist:start~
# ------ Completion ------
# set edit:insert:binding[Tab] = $edit:completion:start~
set edit:insert:binding[Tab] = $edit:completion:smart-start~
set edit:completion:binding[Ctrl-J] = $edit:completion:down-cycle~
set edit:completion:binding[Ctrl-Enter] = $edit:completion:down-cycle~
set edit:completion:binding[Ctrl-K] = $edit:completion:up-cycle~
set edit:completion:binding[Ctrl-H] = $edit:completion:left~
set edit:completion:binding[Ctrl-Backspace] = $edit:completion:left~
set edit:completion:binding[Ctrl-L] = $edit:completion:right~
set edit:completion:binding[Tab] = $edit:completion:down-cycle~
set edit:completion:binding[Shift-Tab] = $edit:completion:up-cycle~
set edit:completion:binding[Enter] = $edit:completion:accept~

# ------ Location ------
set edit:insert:binding[Ctrl-E] = $edit:location:start~

# ------ Listing ------
set edit:listing:binding[Tab] = $edit:listing:down~
set edit:listing:binding[Shift-Tab] = $edit:listing:up~
set edit:listing:binding[Ctrl-Enter] = $edit:listing:down~
set edit:listing:binding[Ctrl-J] = $edit:listing:down~
set edit:listing:binding[Ctrl-K] = $edit:listing:up~
set edit:listing:binding[Ctrl-D] = $edit:listing:page-down~
set edit:listing:binding[Ctrl-U] = $edit:listing:page-up~
set edit:listing:binding[Enter] = $edit:listing:accept~
