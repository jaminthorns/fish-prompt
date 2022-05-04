function _run_async -a global_variable command
    set pid_variable _async_pid_$global_variable
    set callback_function _async_callback_$global_variable
    set value_variable (string join "" _async_value $global_variable _ $fish_pid)

    if set -q $pid_variable && ps -p $$pid_variable >/dev/null
        return
    end

    fish --private --command "set -U $value_variable ($command) && kill -s SIGUSR1 $fish_pid" &

    set -g $pid_variable $last_pid

    function $callback_function -V global_variable -V value_variable -V pid_variable -V callback_function --on-signal SIGUSR1
        if set -q $value_variable
            set -g $global_variable $$value_variable
            set -e $value_variable
            set -e $pid_variable

            commandline -f repaint

            functions -e $callback_function
        end
    end
end

function _clean_async_variables --on-event fish_exit
    set async_variables (set -n | string match "_async_value*")

    if test (count $async_variables) -gt 0
        set -e $async_variables
    end
end
