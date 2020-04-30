# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04 as my_pretty_image

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/force_yes

RUN apt-get update && apt-get install wget gcc libpq-dev


#------------------------------------------------------------------------------
FROM my_pretty_image as python_install

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH="/opt/conda/bin:${PATH}"

RUN --mount=type=cache,target=/opt/conda/pkgs \
    --mount=src=/conda_packages.txt,destination=/conda_packages.txt,ro=true \
    conda install --file /conda_packages.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=src=/pip_packages.txt,destination=/pip_packages.txt,ro=true \
    pip install -r /pip_packages.txt

RUN --mount=src=/py_git,destination=/py_git pip install /py_git

#------------------------------------------------------------------------------
FROM my_pretty_image

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

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN --mount=type=cache,target=/var/cache/apt,id=cache_apt \
    --mount=type=cache,target=/var/lib/apt,id=lib_apt \
    apt-get update && apt-get install docker-ce-cli

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN --mount=src=/full_bazel_install.sh,destination=full_bazel_install.sh bash ./full_bazel_install.sh
ENV PATH="/root/bin:$PATH"

ENV CLI_VERSION 0.7.0
RUN wget https://github.com/cli/cli/releases/download/v${CLI_VERSION}/gh_${CLI_VERSION}_linux_amd64.deb && \
    dpkg -i gh_*_linux_amd64.deb && \
    rm gh_*_linux_amd64.deb

RUN curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN mv mc /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

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

# -------------------------------------------------------------------------
COPY --from=python_install /opt/conda /opt/conda
ENV PATH="/opt/conda/bin:${PATH}"

RUN python -c "print('hello world')"
RUN zsh -c "echo hello world"
RUN echo $PATH && bazel --help && docker-compose --help && docker --help && mc --help
