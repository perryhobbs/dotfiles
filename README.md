# dotfiles

# Color Support
Terminals that support 256 colors can use "palette" (.bash\_functions) to print
out a color-palette.
- You can pass in indices from this palette to create\_prompt.
- If the terminal emulator doesn't support 256 colors, it falls back to sane
  defaults.
- The Vim integrated terminal is a good example here; it sets TERM=xterm for
  some reason.

# iTerm2/Tmux integration 
iTerm2 is integrated with tmux via control mode (man tmux; tmux -CC).
- Eternal Terminal (et) supports tmux control mode.
- Mosh doesn't.

# Language & Locale
tldr; Just override locale to "en\_US.UTF-8"
- The way a locale is chosen in Mac OS is very simplistic;
  - ll\_CC.encoding; where ll=chosen language, CC=country
    - `defaults read -g AppleLocale`
    - `defaults read -g AppleLanguages`
  - Arbitrary combos of language & country (like ja\_US.UTF-8) don't exist
- On Linux, `LANG=ja_JP.UTF-8 man man` works as expected
  - SSH can also pass LANG/LC\_\* using SendEnv
- On Mac, unix progs always use English, seemingly ignoring locale.
   - Might be lacking some localization files; or maybe not compiled in?

#  Vim packages
- Vim 8+ has native package management, so you can just drop it in ~/.vim/
- ALE is a good package for language features.
- Ripgrep (rg) is faster than grep/ag
    - Can pipe results to QuickFix menu
- Tagbar uses tags to give an outline view of code
    - +/- to open/close a fold
    - \*/= to open/close all folds
- SemanticHighlight 
    - Color semantically 
    - Default colors are shit (include colors that disappear in dark or light
      backgrounds), override in vimrc.

# Vim tips
|command|description|
|:------|:----------|
|C-n        | Auto-complete;  opens hover menu                          |
|gf         | Open file under cursor in a new buffer (if it exists)		|
|gq         | (visual) Wrap text to textwidth                           |
|:reg       | List registers	                                    	|
|:ls        | List buffers	                                        	|
|:b foo     | Go to buffer named foo                               		|
|:close 	| Close buffer		                                        |
|:e	%<.h    | Open header file for current c/cpp file in a new buffer   |
|:sp	    | Split current buffer (horizontally)               		|
|:term	    | Open integrated terminal (horizontal)             		|
|:vert X    | Open X vertically                                         |
|:vsp   	| Vertical split current buffer                     		|
|:vert term | Open vertical terminal                            		|



## Extra commands
|command|description|
|:------|:----------|
|gd                 | Go to definition of a token (using ALE)   |
|:Tagbar            | Open file outline                         |
|:TagbarShowTag     | Show tag under cursor                     |
|:RG                | Ripgrep; show results in Quickfix menu    |
|:RG PATTERN %      | Ripgrep current file                      |
|:SemanticHighlight | Turn on Semantic highlighting             |

# Shellcheck?
The reasons for these lines are to disable warnings from static analysis.
- This comes from ALE, via "ShellCheck"
- They're a bit noisy sometimes, but makes writing bash a lot easier.
