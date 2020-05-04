service docker status > /dev/null || service docker start
if [[ $(docker inspect -f '{{.State.Running}}' gabriel_work_env) != "true" ]]; then
    docker restart gabriel_work_env;
fi

docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -it gabriel_work_env bash -c 'cd /projects && zsh'
