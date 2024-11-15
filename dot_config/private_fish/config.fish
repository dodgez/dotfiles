set -x ALTERNATE_EDITOR ""
set -x EDITOR nvim
alias editor="$EDITOR"
alias edit="editor"
alias e="edit"

function ccat
    if type -q bat
        bat $argv
    else
        cat $argv
    end
end
function di
    argparse --name=di -i l c -- $argv
    set _dir $argv[1]
    if test "$_flag_c" = -c
        ccat $argv
    else if test "$_flag_l" = -l; or test -d $_dir
        ls -hAl $argv
    else
        ccat $argv
    end
end

alias untar="tar -xvsf"

alias rimraf="rm -rf"

alias ll="ls -hAl --color=always"

fish_add_path "$HOME/.cargo/bin"
fish_add_path /usr/local/bin

if test -e "$HOME/.config/fish/work_config.fish"
    source "$HOME/.config/fish/work_config.fish"
end

switch (uname -s)
    case "*CYGWIN*"
        source "$HOME/.config/fish/starship_cygwin.fish"
    case '*'
        starship init fish | source
end
