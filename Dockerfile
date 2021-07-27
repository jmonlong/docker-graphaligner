FROM docker.io/library/ubuntu:20.04

MAINTAINER jmonlong@ucsc.edu

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ARG THREADS=4

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        wget \
        curl \
        less \
        gcc \ 
        make \
        bzip2 \
        git \
        sudo \
	pkg-config \
	apt-transport-https \
	software-properties-common \
	gpg-agent \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /build

## GraphAligner
RUN wget -O Miniconda-latest-Linux.sh https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
        bash Miniconda-latest-Linux.sh -b -p /miniconda

ENV PATH /miniconda/bin:$PATH

SHELL ["/bin/bash", "-c"] 

RUN conda init bash && source ~/.bashrc && conda update -n base -c defaults conda

RUN git clone --recursive https://github.com/maickrau/GraphAligner && \
        cd GraphAligner && \
        git fetch --tags origin && \
        git checkout "02c8e2628bba16425dc58cdf67199319f0a7a304" && \
        git submodule update --init --recursive && \
        conda env create -f CondaEnvironment.yml && \
        source activate GraphAligner && \
        make bin/GraphAligner

ENV PATH /build/GraphAligner/bin:$PATH

WORKDIR /home
