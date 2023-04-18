# zsh profile file: .zshenv -> .zprofile -> .zshrc

if [[ "${MOSH}" = 1 ]]; then
    # mosh term 256 color support
    export TERM=xterm-256color
fi
