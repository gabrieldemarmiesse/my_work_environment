
set -e
sudo DOCKER_BUILDKIT=1 docker build -t gabrieldemarmiesse/work_env .
sudo docker push gabrieldemarmiesse/work_env

set +e
sudo docker kill gabriel_work_env

set -e
sudo docker run \
     -d \
     -v -v /var/run/docker.sock:/var/run/docker.sock \
     -v /:/host \
     gabrieldemarmiesse/work_env \
     sleep infinity
