#!/bin/sh

# tldr; Just override locale to "en_US.UTF-8"
# 1. The way a locale is chosen in Mac OS is very simplistic;
#   - ll_CC.encoding; where ll=chosen language, CC=country
#     - $ defaults read -g AppleLocale
#     - $ defaults read -g AppleLanguages
#   - Arbitrary combos of language & country (like ja_US.UTF-8) don't exist
# 2. On Linux, `LANG=ja_JP.UTF-8 man man` works as expected
#   - SSH can also pass LANG/LC_* using SendEnv
# 3. On Mac, unix progs always use English, seemingly ignoring locale.
#    - Might be lacking some localization files; or maybe not compiled in?
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
