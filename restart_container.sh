
set -e
sudo DOCKER_BUILDKIT=1 docker build --progress=plain -t gabrieldemarmiesse/work_env:local_build .
#sudo docker push gabrieldemarmiesse/work_env:local_build

set +e
sudo docker kill gabriel_work_env
sudo docker rm gabriel_work_env

set -e
sudo docker run \
     -d \
     -v conda_cache:/opt/conda/pkgs \
     -v general_cache:/root/.cache \
     -v apt_cache1:/var/cache/apt \
     -v apt_cache2:/var/lib/apt \
     -v /root/.ssh:/root/.ssh \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v /:/host \
     -v history:/root/.zsh_history \
     -v github_config:/root/.config/gh \
     -v /projects:/projects \
     -v /mnt:/mnt \
     --net=host \
     --pid=host \
     --privileged \
     --name gabriel_work_env \
     gabrieldemarmiesse/work_env:local_build \
     bash -c 'service ssh start && sleep infinity'
