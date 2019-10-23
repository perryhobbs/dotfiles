# Override locale
if [ -z "$LANG" ]; then
    LANG=en_US.UTF-8
    #LANG=ja_JP.UTF-8
    export LANG
fi

# Set EDITOR preference
EDITOR="$(command -v vim)" || EDITOR="vi"
export EDITOR

# Source bashrc if it exists
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    #shellcheck source=/home/perryhobbs/.bashrc
    . "$HOME/.bashrc"
fi
