#!/bin/bash

# 生成worker配置
echo "==== generate worker config files ${WORKER_IP} ===="
mkdir $worker_target
kvs["NODE_IP"]=${WORKER_IP}
cp ${SCRIPTDIR}/../configs/kubelet.config.json $worker_target
cp ${SCRIPTDIR}/../service-worker/kubelet.service $worker_target
cp ${SCRIPTDIR}/../configs/kube-proxy.config.yaml $worker_target
cp ${SCRIPTDIR}/../service-worker/kube-proxy.service $worker_target
replace_files $worker_target