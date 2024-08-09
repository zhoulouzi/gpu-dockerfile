service ssh restart
sleep 100s

if [[ "$ROLE" == "master" ]]; then
    /usr/bin/mpirun --oversubscribe --allow-run-as-root \
    -mca plm_rsh_args "-p 2222 -q -o StrictHostKeyChecking=no" \
    -n $WORLD_SIZE -N 8 \
    --host $VC_MASTER_HOSTS,$VC_WORKER_HOSTS \
    --mca plm_rsh_no_tree_spawn 1 \
    -mca btl_tcp_if_include eth0 \
    -bind-to socket \
    -mca pml ob1 -mca btl '^uct' \
    -x NCCL_IB_HCA=mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_4:1,mlx5_5:1,mlx5_6:1,mlx5_7:1,mlx5_8:1 \
    -x NCCL_IB_DISABLE=0 \
    -x NCCL_SOCKET_IFNAME=eth0 \
    -x NCCL_IB_GID_INDEX=0 \
    -x NCCL_DEBUG=INFO \
    -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH \
    /root/nccl-tests/build/all_reduce_perf -b 256M -e 1G -f 2 -g 1 -n 1000 -w 5

    service ssh stop
    
else

    while true; do
    ssh -p 2222 -q -o StrictHostKeyChecking=no $VC_MASTER_HOSTS exit
    if [[ $? -ne 0 ]]; then
        echo "Port 2222 on $VC_MASTER_HOSTS is not open. Exiting program."
        exit 0
    else
        echo "Port 2222 on $VC_MASTER_HOSTS is open."
        sleep 5s
    fi
    
    done
fi
