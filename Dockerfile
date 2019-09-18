# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04 as my_pretty_image

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/force_yes

RUN apt-get update
RUN apt-get install wget


#------------------------------------------------------------------------------
FROM my_pretty_image as python_install

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH="/opt/conda/bin:${PATH}"

RUN --mount=type=cache,target=/opt/conda/pkgs \
    --mount=src=/conda_packages.txt,destination=/conda_packages.txt,ro=true \
    cat /conda_packages.txt | xargs conda install


#------------------------------------------------------------------------------
FROM my_pretty_image

RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8

# prepare the cache.
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=src=/apt_packages.txt,destination=/apt_packages.txt,ro=true \
    apt-get update && \
    cat /apt_packages.txt | xargs apt-get install

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY .zshrc /root/.zshrc
COPY --from=python_install /opt/conda /opt/conda
ENV PATH="/opt/conda/bin:${PATH}"


RUN python -c "print('hello world')"
