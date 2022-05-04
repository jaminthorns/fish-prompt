function _render_prompt -a command_status current_dir git_branch git_status
    set indicator "•"

    set normal (set_color normal)
    set bold (set_color --bold)
    set black_bg (set_color --background black)
    set black (set_color black)
    set brblack (set_color brblack)
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

    if test -n $git_branch
        set git_branch_part "$cyan$git_branch "
    else
        set git_branch_part ""
    end

    if test -n $git_status
        switch $git_status
            case clean
                set git_status_color $green
            case dirty
                set git_status_color $yellow
            case conflict
                set git_status_color $red
            case pending
                set git_status_color $brblack
        end

        set git_status_indicator "$git_status_color$indicator"
    else
        set git_status_indicator "$green$indicator"
    end

    set right "$git_status_indicator$normal$black"

    echo -n "$left$current_dir_part$git_branch_part$right$normal "
end
