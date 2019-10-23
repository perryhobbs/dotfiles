# dotfiles

# Color Support
Terminals that support 256 colors can use "palette" (.bash_functions) to print out a color-palette.
- You can pass in indices from this palette to create_prompt.
- If the terminal emulator doesn't support 256 colors, it falls back to sane defaults.
- The Vim integrated terminal is a good example here; it sets TERM=xterm for some reason.

# iTerm2/Tmux integration 
iTerm2 is integrated with tmux via control mode (man tmux; tmux -CC).
- Eternal Terminal (et) supports tmux control mode.
- Mosh doesn't.

# Language & Locale
tldr; Just override locale to "en_US.UTF-8"
- The way a locale is chosen in Mac OS is very simplistic;
  - ll_CC.encoding; where ll=chosen language, CC=country
    - $ defaults read -g AppleLocale
    - $ defaults read -g AppleLanguages
  - Arbitrary combos of language & country (like ja_US.UTF-8) don't exist
- On Linux, `LANG=ja_JP.UTF-8 man man` works as expected
  - SSH can also pass LANG/LC_* using SendEnv
- On Mac, unix progs always use English, seemingly ignoring locale.
   - Might be lacking some localization files; or maybe not compiled in?

#  Vim
- ALE is a good plugin for language features.
- Vim 8+ has native package management, so you can just drop it in ~/.vim/
- Ripgrep (rg) is faster than ag and pretty easy to use.
    - todo: add ripgrep results to QuickFix window in vim for easy navigation

# Vim tips
- gf to open file under cursor in a new buffer (if it exists)
- gd to go to definition of a token (using ALE)
- :reg    list registers
- :ls     list buffers
- :b foo  go to buffer fuzzy named foo
- :close  close buffer
- :e %<.h open header file for current c/cpp file in a new buffer
- :sp     split current buffer (horizontally)
- :term   open integrated terminal (horizontal)
- :vert X open X vertically
- :vsp    vertical split current buffer
- :vert term  open vertical terminal

# Shellcheck?
The reasons for these lines are to disable warnings from static analysis.
- This comes from ALE, via "ShellCheck"
- They're a bit noisy sometimes, but makes writing bash a lot easier.
