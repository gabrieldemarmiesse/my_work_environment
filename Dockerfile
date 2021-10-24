FROM ubuntu:18.04 as basic_ubuntu

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/force_yes
RUN apt-get update && apt-get install wget gcc libpq-dev curl

FROM basic_ubuntu as python_install

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH="/opt/conda/bin:${PATH}"

RUN --mount=type=cache,target=/opt/conda/pkgs \
    conda install python=3.9

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=src=/pip_packages.txt,destination=/pip_packages.txt,ro=true \
    pip install -r /pip_packages.txt

RUN --mount=src=/py_git,destination=/py_git pip install /py_git

FROM basic_ubuntu as install_docker_compose

RUN wget https://github.com/docker/compose-cli/releases/download/v2.0.0-rc.2/docker-compose-linux-amd64 -O /docker-compose
RUN chmod +x /docker-compose

FROM basic_ubuntu as install_mc
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /mc
RUN chmod +x /mc

FROM basic_ubuntu as install_pgfutter

RUN wget -O /pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.2/pgfutter_linux_amd64
RUN chmod +x /pgfutter

FROM basic_ubuntu as install_buildx

RUN wget -O /docker-buildx https://github.com/docker/buildx/releases/download/v0.6.3/buildx-v0.6.3.linux-amd64
RUN chmod a+x /docker-buildx

FROM basic_ubuntu

RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8

# prepare the cache.
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,target=/var/cache/apt,id=cache_apt \
    --mount=type=cache,target=/var/lib/apt,id=lib_apt \
    --mount=src=/apt_packages.txt,destination=/apt_packages.txt,ro=true \
    apt-get update && \
    cat /apt_packages.txt | xargs apt-get install

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get update && apt-get install nodejs
RUN node -v && npm -v
RUN npm install prettier eslint --global

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN --mount=type=cache,target=/var/cache/apt,id=cache_apt \
    --mount=type=cache,target=/var/lib/apt,id=lib_apt \
    apt-get update && apt-get install docker-ce-cli

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

COPY --from=python_install /opt/conda /opt/conda
ENV PATH="/opt/conda/bin:${PATH}"
COPY --from=install_docker_compose /docker-compose /root/.docker/cli-plugins/
COPY --from=install_mc /mc /usr/local/bin/mc
COPY --from=install_pgfutter /pgfutter /usr/local/bin/pgfutter
COPY --from=install_buildx  /docker-buildx /root/.docker/cli-plugins/

COPY .zshrc /root/.zshrc
RUN git config --global user.email gabrieldemarmiesse@gmail.com
RUN git config --global user.name gabrieldemarmiesse
RUN git config --global core.excludesfile /root/.gitignore
RUN git config --global push.default upstream
RUN git config --global credential.helper "cache --timeout=36000"
COPY user_gitignore /root/.gitignore

RUN echo "Port 3844" >> /etc/ssh/sshd_config
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh/authorized_keys
COPY ./ssh_host_ecdsa_key /etc/ssh/
COPY ./ssh_host_ecdsa_key.pub /etc/ssh/
COPY .pypirc /root/.pypirc

RUN python -c "print('hello world')"
RUN zsh -c "echo hello world"
RUN echo $PATH && docker compose --help && docker --help && mc --help
RUN docker buildx install
