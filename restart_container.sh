
set -e
export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx build -t gabrieldemarmiesse/work_env:local_build \
    --load .

set +e
sudo docker kill gabriel_work_env
sudo docker rm gabriel_work_env

set -e
mkdir -p /root/.mc
touch /root/.mc/config.json
touch /root/.zsh_history
sudo docker run \
     -d \
     -v conda_cache:/opt/conda/pkgs \
     -v general_cache:/root/.cache \
     -v apt_cache1:/var/cache/apt \
     -v apt_cache2:/var/lib/apt \
     -v /root/.ssh:/root/.ssh \
     -v mc_config:/root/.mc/ \
     -v aws_config:/root/.aws/ \
     -v /root/.secret_envs:/root/.secret_envs \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v /tmp:/tmp \
     -v /:/host \
     -v /root/.zsh_history:/root/.zsh_history \
     -v github_config:/root/.config/gh \
     -v /projects:/projects \
     -v /mnt:/mnt \
     --net=host \
     --pid=host \
     --privileged \
     --gpus all \
     --env DISPLAY \
     --name gabriel_work_env \
     gabrieldemarmiesse/work_env:local_build \
     bash -c 'service ssh start && sleep infinity'
