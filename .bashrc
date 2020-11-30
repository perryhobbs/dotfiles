# shellcheck disable=SC1090
# Skip for non-interactive sessions
[ -z "$PS1" ] && return

# shellcheck source=/dev/null
[ -r ~/dotfiles/.bash_functions ] && source ~/dotfiles/.bash_functions

sanitize_path # Get rid of duplicate PATH entries

# Prompt
create_prompt 168 38 220  # colors {host, cwd, separator}
PROMPT_COMMAND=('update_prompt')  # set exit status color & append history

# Options
stty -ixon  # Disable XON/XOFF switch so Ctrl-S can be used for fwd hist search
set -o emacs
shopt -s no_empty_cmd_completion
shopt -s checkwinsize
shopt -s histappend
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups:erasedups
HISTSIZE=5000  # Keep 5000 entries in memory at a time
HISTFILESIZE=-1
HISTFILE=$HOME/.bash_history

# Completions
for cmd in {sudo,which}
do
  complete -c "${cmd}"
done
scripts=(
    jf arcanist mercurial.sh git
    buck
    smcc tw.bash drainer skycli
    yum yum-utils.bash

)
for script in "${scripts[@]}"; do
    if [ -r "/etc/bash_completion.d/${script}" ]; then
        source "/etc/bash_completion.d/${script}"
    elif [ -r "/usr/facebook/ops/rc/bash-completion/${script}" ]; then
        source "/usr/facebook/ops/rc/bash-completion/${script}"
    fi
done

# Aliases
if ls --version >/dev/null 2>&1; then
    alias ls='ls --human-readable --classify --color=auto'
    LS_COLORS=$(gen_ls_colors); export LS_COLORS
else
    alias ls='ls -GF'
    LSCOLORS=$(gen_ls_colors); export LSCOLORS
fi
alias l.='ls -d .*'  # ls dotfiles
alias ll='ls -l'
if command -v vim >/dev/null; then
    alias vi='vim'
fi
if command -v rg >/dev/null; then
    alias rg='rg --type-add buck:BUCK,TARGETS,*.bzl'
fi
dev='et -c "tmux -CC new -A -s main" perryhobbs.sb'
