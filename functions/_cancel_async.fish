function _cancel_async -a global_variable
    set pid_variable _async_pid_$global_variable

    if set -q $pid_variable
        kill $$pid_variable 2>/dev/null
    end
end
