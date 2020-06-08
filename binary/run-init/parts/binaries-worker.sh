#!/bin/bash

echo "==== dispatch k8s worker binaries ${WORKER_IP} ===="
checkPrepare ${WORKER_IP} "binaries-worker"
if [ $prepareResult = 0 ]; then
  ssh root@${WORKER_IP} "mkdir -p /opt/kubernetes/bin"
  ssh root@${WORKER_IP} "sed -i /.*kubernetes.*/d ~/.bashrc; echo 'PATH=/opt/kubernetes/bin:$PATH' >>~/.bashrc"
  scp /root/k8s-binary/worker/* root@${WORKER_IP}:/opt/kubernetes/bin/
  confirmPrepare ${WORKER_IP} "binaries-worker"
fi

# 部署节点命令生效
source ~/.bashrc