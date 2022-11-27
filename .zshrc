# copy from kalilinux 's .zshrc
#
# Adjusted the configuration by @cyhfvg
#
#

# optimize performance {{{
skip_global_compinit=1
# }}}

# basic functions {{{1
function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_EDITOR="nvim"
    # Disable the cursor style feature
    ZVM_CURSOR_STYLE_ENABLED=false
    # init other conf after zsh_vi_mode
    zvm_after_init_commands+=(source_fzf_keybinds)
}

function source_fzf_keybinds() {
    # C-r    command history
    # C-t    file list
    # M-c    change to list dir
    if [ -f /usr/share/fzf/completion.zsh ]; then
        source /usr/share/fzf/completion.zsh
        source /usr/share/fzf/key-bindings.zsh
    elif [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
        source /usr/share/doc/fzf/examples/completion.zsh
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    fi
}

function conf_at_last() {
    # NOTE: last one, zsh-syntax-highlighting
    if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
}
# }}}

# zsh option {{{
setopt re_match_pcre
setopt autocd              # change directory just by typing its name
setopt promptsubst         # enable command substitution in prompt
setopt interactivecomments # allow comments in interactive mode
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt no_beep
unsetopt correct            # (don't do) auto correct mistakes
unsetopt correctall         # (don't do) auto correct mistakes for arguments
#}}}

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

export HISTIGNORE="&:ls:cd:[bf]g:exit:history"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# prompt
#
# %~    current_dir
# %m    host_name
# %n    user
# %b    regular bold
# %B    bold
configure_prompt() {
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n@%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n%B%(#.%F{red}$.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B${$(whoami):0:1}%b - '
            RPROMPT=
            ;;
    esac
}

# prompt select {{{1
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=no
#}}}

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=0

    configure_prompt
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# asdf {{{1
if [ -f $HOME/.asdf/asdf.sh ]; then
    . $HOME/.asdf/asdf.sh
    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
fi
# }}}

# fzf {{{1
if (( $+commands[fzf] )); then
    # 'string
    # !string
    # str1 str2

    export FZF_DEFAULT_OPTS="--layout=reverse --height 80%"

    export FZF_CTRL_T_COMMAND='find -type f'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

    export FZF_ALT_C_COMMAND="find . -type d"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

    # fzf exec chain example
    # echo -e "1\n2\n3\n" | fzf | xargs -r echo

    # tmux split pane mode
    if [ -n "$TMUX" ]; then
        export FZF_TMUX=1
    fi

    # source_fzf_keybinds

    tmuxkillsession () {
        # zsh need `setopt re_match_pcre`
        local sessions
        sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
        local i
        for i in "${(f@)sessions}"
        do
            [[ $i =~ '([^:]*):.*' ]] && {
                echo "Killing $match[1]"
                tmux kill-session -t "$match[1]"
            }
        done
    }

    # select session, or create one
    tm() {
      [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
      if [ $1 ]; then
        tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
      fi
      session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
    }
fi
#}}}

# add alias for dependence binaries {{{1
(( $+commands[batcat] ))        && alias bat='batcat'
(( $+commands[crackmapexec] ))  && alias cme='crackmapexec'
(( $+commands[fzf] ))           && alias fcd='p="$(find . -type d 2>/dev/null | fzf --exit-0)";[ -n "${p}" ] && cd "${p}"'
(( $+commands[fzf] ))           && alias fcp='function bb82ce0d(){ [ $# -lt 1 ] && return || ([ -z "$1" ] && exit 1); p=$(find "$1" 2>/dev/null | fzf --exit-0);[ -n "${p}" ]  && ([ -d "${p}" ]  && cp -r "${p}" . || cp "${p}" . );}; bb82ce0d'
(( $+commands[fzf] ))           && alias fvi='f="$(find . -type f 2>/dev/null | fzf --exit-0)";[ -n "${f}" ] && vi "${f}"'
(( $+commands[gobuster] ))      && alias gobuster-dir-param='gobuster dir --no-error -a "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0" -e -r'
(( $+commands[impacket] ))      && alias smbShareHere='impacket-smbserver -smb2support -username share -password sharepassword share $(pwd)'
(( $+commands[john] ))          && alias john-Rockyou='john --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt'
(( $+commands[ncat] ))          && alias nc='ncat'
(( $+commands[nvim] ))          && alias vi='nvim' || ( (( $+commands[vim] )) && alias vi='vim')
(( $+commands[python3] ))       && alias pyHttpServer='python3 -m http.server' || ( (( $+commands[python2] )) && alias pyHttpServer='python2 -m SimpleHTTPServer')
(( $+commands[searchsploit] ))  && alias search='searchsploit'
(( $+commands[tldr] ))          && alias tldr='tldr -t base16 --linux'
#}}}

# quick command alias {{{
# force zsh to show the complete history
alias ...='cd ../../'
alias ..='cd ../'
alias history="history 0"
alias lnc='nc -lvnp'
alias mkcd='function uagKdsbTu0kLUlL(){ [ $# -lt 1 ] && return || mkdir -p "$@" && cd "$@"; }; uagKdsbTu0kLUlL'
alias rnc='rlwrap -cAr nc -lvnp'
alias stealth_ssh='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'
# }}}

# export global variables {{{
export EDITOR="vi"
(( $+commands[batcat] )) && export PAGER="batcat" || ( (( $+commands[bat] )) && export PAGER="bat" || export PAGER="less")
# }}}

# zsh plugin {{{1
#
# make zplug bolck at the end of .zshrc
#
if [ -f ~/.zplug/init.zsh ]; then
    source ~/.zplug/init.zsh

    # plugins {{{
    zplug "jeffreytse/zsh-vi-mode"
    # }}}

    if ! zplug check; then
        zplug install
    fi
    zplug load
fi
# }}}

# completion style {{{1
# menu style complet, params etc...
zstyle ':completion:*:*:*:*:*' menu select
# case ignore
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# kill completion
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}

# keybindings {{{1
bindkey '^[[3~' delete-char                         # delete
bindkey "^A"   beginning-of-line                    # ctrl-a
bindkey "^E"   end-of-line                          # ctrl-e
bindkey "^U"   backward-kill-line                   # ctrl-u
bindkey "^K"   kill-line                            # ctrl-k
# C-O change prompt
bindkey ^O toggle_oneline_prompt
#}}}


#
#
#
#
# load something at last, zsh-syntax-highlightin etc...
#
#
#
conf_at_last
