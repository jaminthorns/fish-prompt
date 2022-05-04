if not status is-interactive
    exit
end

function _set_prompt_variables --on-event fish_prompt
    if test $status -eq 0
        set -g _prompt_command_status success
    else
        set -g _prompt_command_status failure
    end

    set -g _prompt_current_dir (basename (prompt_pwd))

    set prev_git_root $_prompt_git_root
    set -g _prompt_git_root (git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    set git_root_status $status

    if test "$prev_git_root" != "$_prompt_git_root"
        set -e _prompt_git_branch _prompt_git_status
    end

    if test $git_root_status -eq 0
        set -q _prompt_git_branch || set -g _prompt_git_branch ""
        set -q _prompt_git_status || set -g _prompt_git_status pending

        _run_async _prompt_git_branch '
        git --no-optional-locks symbolic-ref --short --quiet HEAD ||
        git --no-optional-locks rev-parse --short HEAD'

        _run_async _prompt_git_status '
        set modified (git --no-optional-locks status --porcelain | string sub --length 2)
        set conflicted (string match --entire "U" $modified)

        if test (count $modified) -eq 0
            echo -n clean
        else if test (count $conflicted) -eq 0
            echo -n dirty
        else
            echo -n conflict
        end'
    else
        _cancel_async _prompt_git_branch
        _cancel_async _prompt_git_status
    end
end
