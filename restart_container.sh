
set -e
sudo DOCKER_BUILDKIT=1 docker build -t gabrieldemarmiesse/work_env:local_build .
#sudo docker push gabrieldemarmiesse/work_env:local_build

set +e
sudo docker kill gabriel_work_env
sudo docker rm gabriel_work_env

set -e
sudo docker run \
     -d \
     -v conda_cache:/opt/conda/pkgs \
     -v apt_cache1:/var/cache/apt \
     -v apt_cache2:/var/lib/apt \
     -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v /:/host \
     --name gabriel_work_env \
     gabrieldemarmiesse/work_env:local_build \
     sleep infinity
