# zsh profile file : ~/.zshenv -> ~/.zprofile -> ~/.zshrc

# $PATH {{{1
typeset -U path PATH

# ~/.local/bin
(( $+commands[pipx] )) && path=( $path ${PATH}:${HOME}/.local/bin )
# ~/.scripts
[[ -d ${HOME}/.scripts ]] && path=( $path ${PATH}:${HOME}/.scripts )
# ~/.local/mybin
[[ -d ${HOME}/.local/mybin ]] && path=( $path  ${PATH}:${HOME}/.local/mybin )

export PATH
# }}}

# mosh env {{{1
ps -p $PPID | grep mosh-server > /dev/null
if [[ "$?" == "0" ]]; then
    export MOSH=1
else
    export MOSH=0
fi
# }}}

## rust env {{{1
# . "$HOME/.cargo/env"
## }}}

## functions {{{1
# mkcd
function uagKdsbTu0kLUlL(){ [ $# -lt 1 ] && return || mkdir -p "$@" && cd "$@"; }
# fcp
function bb82ce0d(){ [ $# -lt 1 ] && return || ([ -z "$1" ] && exit 1); p=$(find "$1" 2>/dev/null | fzf --exit-0);[ -n "${p}" ]  && ([ -d "${p}" ]  && cp -r "${p}" . || cp "${p}" . );}
## }}}
