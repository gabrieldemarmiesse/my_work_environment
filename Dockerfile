FROM ubuntu:18.04 as my_pretty_image

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/force_yes


RUN apt-get update
RUN apt-get install wget

FROM my_pretty_image as python_install

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh


ENV PATH="/opt/conda/bin:${PATH}"


FROM my_pretty_image

RUN apt-get install -y vim git docker

COPY --from=python_install /opt/conda /opt/conda
ENV PATH="/opt/conda/bin:${PATH}"


RUN python -c "print('hello world')"
