function fish_prompt
    set exit_status $status

    if not set -q -g _prompt_functions_defined
        set -g _prompt_functions_defined

        function _git_no_lock
            git --no-optional-locks $argv
        end

        function _git_in_repository
            _git_no_lock rev-parse --is-inside-work-tree >/dev/null 2>&1
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
    end

    set left_mark "«"
    set right_mark "»"

    set cyan (set_color -o cyan)
    set yellow (set_color -o yellow)
    set red (set_color -o red)
    set green (set_color -o green)
    set blue (set_color -o blue)
    set normal (set_color normal)

    if test $exit_status = 0
        set left_color $green
    else
        set left_color $red
    end

    set current_dir (basename (prompt_pwd))
    set left "$left_color$left_mark $blue$current_dir"

    if _git_in_repository
        set branch (_git_branch || _git_commit)
        set modified (_git_modified)
        set conflicted (string match --entire "U" $modified)

        if test (count $modified) = 0
            set right_color $green
        else if test (count $conflicted) = 0
            set right_color $yellow
        else
            set right_color $red
        end

        set right "$cyan$branch $right_color$right_mark"
    else
        set right "$green$right_mark"
    end

    echo -n "$left $right $normal"
end
