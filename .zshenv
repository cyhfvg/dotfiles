# zsh profile file : ~/.zshenv -> ~/.zprofile -> ~/.zshrc

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
