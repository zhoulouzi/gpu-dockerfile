FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu20.04

ARG GPU_BURN_VERSION=master
ARG COMPUTE=80

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/gpu-burn

RUN git clone --depth 1 --branch "${GPU_BURN_VERSION}" \
        https://github.com/wilicc/gpu-burn.git . && \
    make -j"$(nproc)" COMPUTE="${COMPUTE}" && \
    rm -rf .git && \
    rm -f *.o

ENTRYPOINT ["/opt/gpu-burn/gpu_burn"]
CMD ["300"]
