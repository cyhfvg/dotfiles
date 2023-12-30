# zsh profile file : ~/.zshenv -> ~/.zprofile -> ~/.zshrc

# $PATH {{{1
typeset -U path PATH

# ~/.local/bin
path=( $path ${HOME}/.local/bin(N-/) )
# ~/.scripts
path=( $path ${HOME}/.scripts(N-/) )
# ~/.local/mybin
path=( $path  ${HOME}/.local/mybin(N-/) )
# ~/.yarn/bin
(( $+commands[yarn] ))    && path=( $path  ${HOME}/.yarn/bin(N-/) )
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
[[ -f ${HOME}/.cargo/env ]] && . "$HOME/.cargo/env"
## }}}

## functions {{{1
# mkcd
function uagKdsbTu0kLUlL(){ [ $# -lt 1 ] && return || mkdir -p "$@" && cd "$@"; }
# fcp
function bb82ce0d(){ [ $# -lt 1 ] && return || ([ -z "$1" ] && exit 1); p=$(find "$1" 2>/dev/null | fzf --exit-0);[ -n "${p}" ]  && ([ -d "${p}" ]  && cp -r "${p}" . || cp "${p}" . );}
## }}}
