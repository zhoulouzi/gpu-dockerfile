#FROM nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu20.04
FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu20.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install base dependencies
RUN apt-get update && \
    apt-get install -y \
    vim \
    wget \
    python3.8 \
    python3.8-dev \
    python3.8-distutils

RUN ln -s /usr/bin/python3 /usr/bin/python

# install net tools
RUN apt-get update && \
    apt-get install -y \
    iproute2 \
    dnsutils \
    iputils-ping \
    telnet \
    perftest

# Install openmpi
RUN apt-get update && apt-get install -y \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev

# Install RDMA libraries
RUN apt-get update && apt-get install -y \
    ibverbs-utils libibverbs-dev libibumad3 libibumad-dev librdmacm-dev rdmacm-utils infiniband-diags ibverbs-utils 

# Install nccl-tests
WORKDIR /root/nccl-tests
RUN wget -q -O - https://github.com/NVIDIA/nccl-tests/archive/refs/tags/v2.13.9.tar.gz | tar --strip-components=1 -xzf - \
    && cd /root/nccl-tests && make -j 10 MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi/

RUN ldconfig

# Install SSH dependencies for MPI
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && mkdir -p /var/run/sshd
RUN sed -i 's/[ #]\(.*StrictHostKeyChecking \).*/ \1no/g' /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config

