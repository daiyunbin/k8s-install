#!/bin/bash

echo "==== preparing docker ${WORKER_IP} ===="
checkPrepare ${WORKER_IP} "docker"
if [ $prepareResult = 0 ]; then
  ssh root@${WORKER_IP} < $SCRIPTDIR/parts/docker-install.sh
  confirmPrepare ${WORKER_IP} "docker"
fi
# docker status
checkStatus "docker" 0 ${WORKER_IP}

# 下载镜像
for imageName in "pause:3.1" "coredns:1.3.1"; do
  ssh root@${WORKER_IP} "docker pull registry.cn-shanghai.aliyuncs.com/k8s-meng/${imageName}"
  ssh root@${WORKER_IP} "docker tag registry.cn-shanghai.aliyuncs.com/k8s-meng/${imageName} k8s.gcr.io/${imageName}"
  ssh root@${WORKER_IP} "docker rmi registry.cn-shanghai.aliyuncs.com/k8s-meng/${imageName}"
done