bash
ulimit -a
service ssh restart


sleep 60s

if [ "ROLE" = "master" ]; then
    mpirun --oversubscribe --allow-run-as-root \
    -mca plm_rsh_args "-p 2222 -q -o StrictHostKeyChecking=no" \
    -n 32 -N 8 \
    --host $VC_MASTER_HOSTS,$VC_WORKER_HOSTS \
    --mca plm_rsh_no_tree_spawn 1 \
    -mca btl_tcp_if_include eth0 \
    -bind-to socket \
    -mca pml ob1 -mca btl '^uct' \
    -x NCCL_IB_HCA=mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_4:1,mlx5_5:1,mlx5_6:1,mlx5_7:1,mlx5_8:1 \
    -x NCCL_IB_DISABLE=0 \
    -x NCCL_SOCKET_IFNAME=eth0 \
    -x NCCL_IB_GID_INDEX=3 \
    -x NCCL_DEBUG=INFO \
    /root/nccl-tests/build/all_reduce_perf -b 256M -e 8G -f 2 -g 1 -n 1000 -w 20

    service ssh stop
else
    while true; do
    nc -vv -z $VC_MASTER_HOSTS 2222
    if [ $? -ne 0 ]; then
        echo "Port 2222 on $VC_MASTER_HOSTS is not open. Exiting program."
        exit 0
    else
        echo "Port 2222 on $VC_MASTER_HOSTS is open."
    fi
    sleep 1
    done
fi
