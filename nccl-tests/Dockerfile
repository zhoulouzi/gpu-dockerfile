FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu20.04

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

# Install nccl (already install in base image)
#RUN apt-get update && \
#apt-get install -y \
#libnccl2=2.19.3-1+cuda12.2 \
#libnccl-dev=2.19.3-1+cuda12.2

ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu/:/usr/local/cuda/lib64/:$LD_LIBRARY_PATH

# Install nccl-tests
WORKDIR /root/nccl-tests
RUN wget -q -O - https://github.com/NVIDIA/nccl-tests/archive/refs/tags/v2.13.9.tar.gz | tar --strip-components=1 -xzf - \
    && cd /root/nccl-tests && make -j 10 MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi/


# Install SSH dependencies for MPI
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && mkdir -p /var/run/sshd
RUN sed -i 's/[ #]\(.*StrictHostKeyChecking \).*/ \1no/g' /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
