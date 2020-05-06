service docker status > /dev/null || service docker start
if [[ $(docker inspect -f '{{.State.Running}}' gabriel_work_env) != "true" ]]; then
    docker restart gabriel_work_env;
fi

[ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &> /dev/null
docker exec -it gabriel_work_env bash -c 'cd /projects && zsh'
