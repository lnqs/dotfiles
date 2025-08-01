###############################################################################
# lnqs' .zshrc
# A lot of stuff is taken from grml's zshrc (see <http://grml.org/zsh/>, GPLv2)
###############################################################################

if [[ $(uname) == "Darwin" ]]; then
    source $HOME/.config/environment.d/*
fi

###############################################################################
#     PREREQUISITES
###############################################################################

# loaded early since it's needed at various places
autoload -U add-zsh-hook


###############################################################################
#     SETUP ENVIRONMENT
###############################################################################

# enable 265 colors
if [[ "$TERM" = "xterm" ]]; then
    export TERM="xterm-256color"
fi


###############################################################################
#     ALIASES
###############################################################################

# colors for ls. Also, human-readable sizes are great.
if [[ $(uname) != "Darwin" ]]; then
    alias ls='ls -b -CF -h --color=auto'
else
    alias ls='ls -b -CF -h'
fi

# don't grep in binary files by default
alias grep='grep -I'

# less typing for starting nvim
alias n=nvim

# less typing for running ag
alias a=ag

# sudoedit shortcut
alias sn=sudoedit

# cat images on commandline
alias icat="kitty +kitten icat"

# side by side diff
alias kdiff="kitty +kitten diff"

###############################################################################
#     OPTIONS
###############################################################################

# append history list to the history file and share it between instances
setopt append_history
setopt share_history

# save timestamp and duration for each command executed in history
setopt extended_history

# keep only the newest invocation of a command in history
setopt histignorealldups

# don't add commands prefixed with a whitespace to the history
setopt histignorespace

# enable #, ~ and ^ in globbing
setopt extended_glob

# display PID when suspending processes
setopt longlistjobs

# try to avoid the 'zsh: no matches found...'
setopt nonomatch

# report the status of backgrounds jobs immediately
setopt notify

# when a command completion is attempted, make sure the command path is hashed
setopt hash_list_all

# not just at the end
setopt completeinword

# Don't send SIGHUP to background processes when the shell exits
setopt nohup

# make cd push the old directory onto the directory stack
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# don't error out when unset parameters are used
setopt unset

# report times as if invoked with `time' when a command takes more than 5 secs
REPORTTIME=5

# history
HISTFILE=${HOME}/.zsh/history
HISTSIZE=5000
SAVEHIST=10000


###############################################################################
#     COLORS
###############################################################################

autoload -U colors && colors

# support colors in ls
if [[ $(uname) != "Darwin" ]]; then
    eval $(dircolors -b)
fi

# support colors in less
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# colors in zsh itself
export ZLSCOLORS="${LS_COLORS}"


###############################################################################
#     KEYBINDINGS
###############################################################################


# initialize
bindkey -e

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[Ctrl+H]='^H'
key[Ctrl+Z]='^Z'
key[Ctrl+Up]='^[[1;5A'
key[Ctrl+Down]='^[[1;5B'
key[Ctrl+Left]='^[[1;5D'
key[Ctrl+Right]='^[[1;5C'

# setup key accordingly
bindkey "${key[Home]}"     beginning-of-line
bindkey "${key[End]}"      end-of-line
bindkey "${key[Insert]}"   overwrite-mode
bindkey "${key[Delete]}"   delete-char
bindkey "${key[Up]}"       up-line-or-history
bindkey "${key[Down]}"     down-line-or-history
bindkey "${key[Left]}"     backward-char
bindkey "${key[Right]}"    forward-char
bindkey "${key[PageUp]}"   beginning-of-buffer-or-history
bindkey "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# ctrl+h sends command to history without executing it

if [[ "$TERM" =~ "kitty" ]]; then
    commit-to-history() {
        print -s ${(z)BUFFER}
        zle send-break
    }
    zle -N commit-to-history
    bindkey "${key[Ctrl+H]}" commit-to-history
fi

# ctrl+z continues the last stopped job
raise-stopped-to-fg() {
    if (( ${#jobstates} )); then
        zle .push-input
        [[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
        BUFFER="${BUFFER}fg"
        zle .accept-line
    else
        zle -M 'No background jobs. Doing nothing.'
    fi
}
zle -N raise-stopped-to-fg
bindkey "${key[Ctrl+Z]}" raise-stopped-to-fg

# ctrl+up/ctrl+down search the history incremental
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "${key[Ctrl+Up]}" history-beginning-search-backward-end
bindkey "${key[Ctrl+Down]}" history-beginning-search-forward-end

# ctrl+left/ctrl+right jumps to previous/next word
bindkey "${key[Ctrl+Left]}" backward-word
bindkey "${key[Ctrl+Right]}" forward-word


###############################################################################
#     DIRSTACK HANDLING
###############################################################################

# Keep a stack of recent directories
DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${HOME}/.zsh/dirs}

if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    # "cd -" won't work after login by just setting $OLDPWD, so
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    builtin print -l ${(u)my_stack} >! ${DIRSTACKFILE}
}


###############################################################################
#     AUTOCOMPLETION
###############################################################################

# NOTE: Disable 'HashKnownHosts' in /etc/ssh/ssh_config to allow
#       autocompletion to work with ssh

autoload -U compinit && compinit

setopt completealiases

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' \
       format "%{$fg_bold[yellow]%}completing %d%{$reset_color%}"
zstyle ':completion:*:messages' \
       format "%{$fg_bold[green]%}completing %d%{$reset_color%}"
zstyle ':completion:*:warnings' \
       format "%{$fg_bold[red]%}no matches found%{$reset_color%}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
        'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


###############################################################################
#     HELPERS
###############################################################################

function try_load() {
    local name="$1"
    shift

    for p in $*; do
        [[ -f "$p" ]] && source "$p" && unset p && return
    done

    unset p
    echo "Failed to load $name" >&2
}


###############################################################################
#     PROMPT
###############################################################################

eval "$(starship init zsh)"

###############################################################################
#     TERMINAL TITLE
###############################################################################

set_title() {
    case $TERM in
        (xterm*|rxvt*)
            builtin print -n "\e]0;$*\a"
            ;;
    esac
}

set_title_program_name() {
    set_title "${(%):-"%n@%m:"} $1"
}

set_title_pwd() {
    set_title ${(%):-"%n@%m: %~"}
}

add-zsh-hook preexec set_title_program_name
add-zsh-hook precmd set_title_pwd


###############################################################################
#     MISC
###############################################################################

# standard math functions like sin()
zmodload zsh/mathfunc

# some useful modules
zmodload -a zsh/stat zstat
zmodload -a zsh/zpty zpty
zmodload -ap zsh/mapfile mapfile

# zmv for batch renaming/moving
autoload -U zmv

# ssh agent
if [[ $(uname) != "Darwin" ]]; then
    # Start ssh-agent if not running already
    SSH_ENV="$HOME/.ssh/environment"

    function start_ssh_agent {
        echo "Starting new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
    }

    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_ssh_agent;
        }
    else
        start_ssh_agent;
    fi

    ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
fi


###############################################################################
#     fzf
###############################################################################

try_load fzf \
    /usr/share/fzf/key-bindings.zsh \
    /usr/local/opt/fzf/shell/key-bindings.zsh
bindkey '^P' fzf-file-widget


###############################################################################
#     NVM
###############################################################################

source /usr/share/nvm/init-nvm.sh

if [[ -n "$NVM_DIR" ]]; then
    cd () {
        builtin cd $*
        if [[ -f .nvmrc ]]; then
            nvm use
        fi
    }
fi


###############################################################################
#     RESTIC
###############################################################################

if ( whence -p restic >/dev/null ); then
    function restic() {
        AWS_ACCESS_KEY_ID="$RESTIC_B2_KEY_ID" AWS_SECRET_ACCESS_KEY="$RESTIC_B2_KEY" "$(whence -p restic)" "$@"
    }
fi

###############################################################################
#     PYENV
###############################################################################

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

###############################################################################
#     AUTOSUGGESTIONS
###############################################################################

# aur/zsh-autosuggestions

try_load zsh-autosuggestions \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

###############################################################################
#     AWS
###############################################################################

aws-profile() {
    profile="$1"
    if ( grep "\[profile $profile\]" "$HOME/.aws/config" >/dev/null ); then
        export AWS_PROFILE="$profile"
        kubectl config use-context "$profile"
    else
        echo "No such aws profile" >&2
    fi
}

###############################################################################
#     DEVICE SPECIFIC
###############################################################################

if [[ -e "$HOME/.zshrc.$(hostname)" ]]; then
    source "$HOME/.zshrc.$(hostname)"
fi

###############################################################################
#     SYNTAX HIGHLIGHTING
###############################################################################

# has to stay at the end of the file
# community/zsh-syntax-highlighting

try_load zsh-syntax-highlighting \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


