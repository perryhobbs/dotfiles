# Prompt
function create_prompt(){
    # Construct a colored prompt given 3 colors
    color_off=$(_zero_width "$(tput sgr0)")
    if [[ ${TERM} =~ 256color ]]; then
        color_fail=$(tput setaf 9)
        color_ok=$(tput setaf 78)
        color_A=$(get_prompt_color "$1")
        color_B=$(get_prompt_color "$2")
        color_C=$(get_prompt_color "$3")
    else
        # Fallback to 8-bit color index
        color_fail=$(tput setaf 1)
        color_ok=$(tput setaf 2)
        color_A=$(get_prompt_color 3)
        color_B=$(get_prompt_color 4)
        color_C=$(get_prompt_color 5)
    fi
    PS1="${color_C}["
        PS1+="${color_A}${HOSTNAME%%.*}"
        PS1+="${color_C}:"
        PS1+="${color_B}\\W"
    PS1+="${color_C}]"
    PS1+="["
        # color_D is changed through PROMPT_COMMAND, hence the single quotes
        PS1+='\[${color_D}\]'  # escapes are interpreted *before* expansion
        PS1+='$?'
    PS1+="${color_C}]"
    PS1+="\$ "
    PS1+="${color_off}"
}

function update_prompt(){
    # Set exit code status color; PROMPT_COMMAND is a good place for this
    # shellcheck disable=SC2181
    [ "$?" != 0 ] && color_D=${color_fail} || color_D=${color_ok}
    # Append to history file at each prompt (default is upon exit)
    history -a
}

function get_prompt_color(){
    local id="$1"
    printf "%s" "$(_zero_width "$(tput setaf "$id")")"
}

# Color Functions
function palette(){
    # Print a numbered color palette in the terminal
    # Color text (fg) or background (default)
    # args: fg |  bg
    local termcap  # man terminfo
    case "$1" in
        "fg")
            termcap="setaf"
            ;;
        *)
            termcap="setab"
            ;;
    esac
    local func="_gen_colors $termcap"
    # Print 16-bit colors
    printf '(Normal)%s\n' "$($func {0..7})"
    printf '(Bright)%s\n' "$($func {8..15})"
    # Print 256-bit colors
    for ((i=0;i<12;i++)); do
        $func $(seq $((i*18+16)) $((i*18+33)))
    done
    # Greyscale
    $func {232..243}
    $func {244..255}
}

function gen_ls_colors(){
    # Output LS_COLORS/LSCOLORS string from a human-readable config
    local is_gnu
    # shellcheck disable=SC2015
    ls --version >/dev/null 2>&1 && is_gnu=1 || unset is_gnu
    # Hack up a map-like struct
    local color_settings=(
        "di: bold blue"              # directory
        "ln: bold cyan"              # symbolic link
        "so: bold magenta"           # socket
        "pi: bold yellow"            # named pipe
        "ex: bold green"             # executable file
        "bd: bold yellow"            # block device
        "cd: bold yellow"            # character device
        "su: bold white onred"       # setuid
        "sg: bold black onyellow"    # setgid
        "tw: black ongreen"          # other writeable + sticky
        "ow: blue ongreen"           # other writeable
        # GNU ls only
        "or: bold cyan onred"        # orphaned symlink
        "ca: bold yellow onred"      # file with capabilities
    )
    local lscolors
    for setting in "${color_settings[@]}"; do
        local colors seq
        colors=("${setting#*:}")
        # shellcheck disable=SC2068
        seq=$(_gen_color_seq ${colors[@]})
        if [ -n "${is_gnu}" ]; then  # GNU ls
            local key=${setting%%:*}
            lscolors+="${key}=${seq}:"
        else  # BSD ls
            local ids
            ids=("${seq//;/ }")
            # shellcheck disable=SC2068
            lscolors+=$(_get_bsd_color_pair ${ids[@]})
        fi
    done
    printf "%s" "${lscolors}"
}

# Other Functions
function sanitize_path(){
    PATH=$(
        printf "%s" "$PATH" |
        awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }'
    )
    export PATH
}

# Implementation details
function _gen_color_seq(){
    # Return a color code sequence given a list of keywords
    # Eg. "bold blink red ongreen" would return "1;5;31;42"
    # Sequences can be used directly in LS_COLORS.
    # They can also be escaped in various ways for use in the terminal.
    # - for terminal text use: \E[<seq>m
    # - for bash prompt use: \[\E[<seq>m\]
    # man terminfo/Color Handling
    local colors=(
        "black" "red" "green" "yellow"
        "blue" "magenta" "cyan" "white" "_"
    )
    local attributes=(
        "normal" "bold" "dim" "_" "underline"
        "blink" "_" "reverse" "hidden"
    )
    local controls=( "${colors[@]}" "${attributes[@]}" )
    local sequence
    for arg in "$@"; do
        local id
        # shellcheck disable=SC2068,SC2086
        id="$(__find_index $arg ${controls[@]})"
        [ -z "$id" ] && continue
        if [ "$id" -lt 9 ]; then
            ((id+=30))
            [[ "$arg" =~ "bright" ]] && ((id+=60))  # Bright color
            [[ "$arg" =~ "on" ]] && ((id+=10))  # Background color
        else
            id="$((id % 9))"  # Attribute
        fi
        sequence+="${id};"
    done
    printf "%s" ${sequence%?}  # Strip last ';'
}

function _get_bsd_color_pair(){
    # Convert color code values to BSD LSCOLORS style (BSD/Darwin/Mac OS)
    # Colors represented by letter pairs a-h & A-H (bold)
    local offset_dec=97  # decimal for offset 'a'
    local fg_hex=0x78  # hex for "default" color 'x'
    local bg_hex="${fg_hex}"
    for id in "$@"; do
        if [ "$id" -lt 9 ]; then
            # BSD ls only supports the "bold" attribute
            [ "$id" -ne 0 ] && offset_dec=$(printf "%d" "'A'")
            continue
        fi
        # BSD ls doesn't support "bright" colors
        [ "$id" -ge 50 ] || [ "$id" -lt 30 ] && ((id-=60))
        if [ "$id" -ge 30 ] && [ "$id" -lt 40 ]; then
            fg_hex=$(printf "0x%x" "$((id%10 + offset_dec))")
        elif [ "$id" -ge 40 ] && [ "$id" -lt 50 ]; then
            bg_hex=$(printf "0x%x" "$((id%10 + offset_dec))")
        fi
    done
    printf "%s" "$(echo "${fg_hex}${bg_hex}" | xxd -r)"
}

function _gen_colors_raw(){
    # Print raw color escape sequences without consulting tput
    # Less portable, but quicker with no forking.
    local offset="$1"; shift  # 0 (fg), or 10 (bg)
    for n in "$@"; do
        if [ "$n" -gt 15 ]; then
            printf '\e[%d;5;%dm %03d ' "$((38 + offset))" "$n" "$n"
        elif [ "$n" -gt 7 ]; then
            printf '\e[%dm %03d ' "$((90 + offset + n%8))" "$n"
        else
            printf '\e[%dm %03d ' "$((30 + offset + n))" "$n"
        fi
    done
    printf '\e[0m \n'
}

function _gen_colors(){
    # Wrapper around tput to lookup & print escape sequences for setting
    # color graphics. Accepts a "terminal capability function" & range of ids
    local termcap="$1"; shift  # man terminfo
    local use_tput=1  # Unset to use raw escapes (faster, but less portable)
    # unset use_tput
    if [ -n "$use_tput" ]; then
        for n in "$@"; do
            # shellcheck disable=SC2086
            printf '%s %03d ' "$(tput $termcap $n)" "$n"
        done
        tput sgr0; echo
    else
        # Try generating the control sequences by hand
        # shellcheck disable=SC2015
        [ "$termcap" == "setab" ] && local offset=10 || local offset=0
        _gen_colors_raw "$offset" "$@"
    fi
}

function _zero_width(){
    # Mark characters as zero width (eg. ANSI escape sequences).
    # Needed to accurately calculate width of Bash prompt.
    printf '\[%s\]'  "$1"
}

function  __find_index(){
    # Get the index of an element in an array
    local match="$1"; shift  # Pattern to find
    local array=("$@")  # Array to search
    for i in "${!array[@]}"; do
        local element="${array[$i]}"
        if [ -z "${match##*$element*}" ]; then
            printf "%s" "${i}"
            return
        fi
    done
}
