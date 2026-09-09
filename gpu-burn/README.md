# gpu-burn Docker 镜像

这是一个基于 NVIDIA CUDA 的 [gpu-burn](https://github.com/wilicc/gpu-burn) GPU 稳定性与压力测试镜像。镜像构建时从 gpu-burn 源码编译，容器启动后默认运行 300 秒测试。

## 前置条件

- Docker
- NVIDIA Driver
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- 具备 CUDA 运行环境的 NVIDIA GPU

## 构建镜像

在 `gpu-burn` 目录执行：

```bash
docker build -t gpu-burn:12.6.3 .
```

Dockerfile 支持以下构建参数：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `GPU_BURN_VERSION` | `master` | gpu-burn Git 分支、Tag 或提交版本 |
| `COMPUTE` | `80` | 编译时传递给 gpu-burn 的 CUDA Compute Capability |

例如，针对 Compute Capability 8.0 并固定源码版本构建：

```bash
docker build \
  --build-arg GPU_BURN_VERSION=master \
  --build-arg COMPUTE=80 \
  -t gpu-burn:latest .
```

`COMPUTE` 应根据目标 GPU 的 Compute Capability 设置。部署到不同架构的 GPU 时，建议重新构建对应架构的镜像。

## 使用方法

### 默认运行 300 秒

```bash
docker run --rm --gpus all gpu-burn:latest
```

### 指定测试时长

容器的默认命令为 `300`，表示运行 300 秒。可以在镜像名后传入秒数覆盖默认值：

```bash
docker run --rm --gpus all gpu-burn:latest 600
```

### 使用指定 GPU

通过 `NVIDIA_VISIBLE_DEVICES` 选择要测试的 GPU：

```bash
docker run --rm \
  --gpus 'device=0' \
  gpu-burn:latest 300
```

也可以使用环境变量：

```bash
docker run --rm \
  --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=0,1 \
  gpu-burn:latest 300
```

## 注意事项

- gpu-burn 会持续占用较高的 GPU 计算资源和显存，请勿在生产业务 GPU 上直接运行。
- 测试期间请关注 GPU 温度、功耗和显存使用情况，并确保主机散热正常。
- 测试结果及错误信息直接输出到容器标准输出；使用 `--rm` 可在测试完成后自动清理容器。
- `--gpus` 参数需要 NVIDIA Container Toolkit 支持，Docker 默认不会自动提供 GPU 设备。

## 相关项目

- [wilicc/gpu-burn](https://github.com/wilicc/gpu-burn)
- [NVIDIA CUDA Containers](https://hub.docker.com/r/nvidia/cuda)
