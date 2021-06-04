function _git_no_lock
    git --no-optional-locks $argv
end

function _git_in_repository
    _git_no_lock rev-parse --is-inside-work-tree &>/dev/null
end

function _git_branch
    _git_no_lock symbolic-ref --short --quiet HEAD
end

function _git_commit
    _git_no_lock rev-parse --short HEAD
end

function _git_modified
    _git_no_lock status --porcelain | string sub --length 2
end

function _render_prompt -a command_status current_dir branch git_status
    set indicator "•"

    set normal (set_color normal)
    set bold (set_color --bold)
    set black_bg (set_color --background black)
    set black (set_color black)
    set cyan (set_color cyan)
    set yellow (set_color yellow)
    set red (set_color red)
    set green (set_color green)
    set blue (set_color blue)

    switch $command_status
        case success
            set command_status_color $green
        case failure
            set command_status_color $red
    end

    set left "$black$bold$black_bg$command_status_color$indicator "
    set current_dir_part "$blue$current_dir "

    if test (count $git_status) -gt 0
        switch $git_status
            case clean
                set git_status_color $green
            case dirty
                set git_status_color $yellow
            case conflict
                set git_status_color $red
        end

        set branch_part "$cyan$branch "
        set git_status_indicator "$git_status_color$indicator"
    else
        set branch_part ""
        set git_status_indicator "$green$indicator"
    end

    set right "$git_status_indicator$normal$black"

    echo -n "$left$current_dir_part$branch_part$right$normal "
end

function fish_prompt
    if test $status -eq 0
        set command_status success
    else
        set command_status failure
    end

    set current_dir (basename (prompt_pwd))

    if _git_in_repository
        set branch (_git_branch || _git_commit)
        set modified (_git_modified)
        set conflicted (string match --entire "U" $modified)

        if test (count $modified) -eq 0
            set git_status clean
        else if test (count $conflicted) -eq 0
            set git_status dirty
        else
            set git_status conflict
        end
    end

    _render_prompt $command_status $current_dir $branch $git_status
end
