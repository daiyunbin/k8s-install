#!/bin/bash

# exit when error
#set -o errexit

# 部署配置目录
target="/root/k8s-install-target"

# 所有判断是yes
yes_to_all=$1

if [ ! -e ${target} ]; then
  echo "the masters has not been initailized!!!"
  exit 1
fi

read -r -p "please input worker ip [192.168.193.133] " WORKER_IP
if [ ! -n "${WORKER_IP}" ] ;then
    echo "please input worker ip"
    exit 1
fi

worker_target=${target}/worker-${WORKER_IP}
if [ -e $worker_target ]; then
  echo "the worker has been initailized!!!"
  exit 1
fi

read -r -p "please input worker hostname [k8s-w1] " WORKER_HOSTNAME
if [ ! -n "${WORKER_HOSTNAME}" ] ;then
    echo "please input worker hostname"
    exit 1
fi

# 替换变量的列表
declare -A kvs=()
declare -x SCRIPTDIR=''

# 引进使用的函数
. ./funcs.sh

# 获取脚本路径
getScriptDir

echo "==== 设置替换变量的列表 ===="
initKvs ${SCRIPTDIR}/../config.properties

# 配置目录
ssh root@${WORKER_IP} "rm -rf /etc/kubernetes; mkdir -p /etc/kubernetes/pki"

# 设置hosts
. ${SCRIPTDIR}/parts/hosts-sync.sh

# 工作节点的准备工作，包含 prepare 和 binaries
. ${SCRIPTDIR}/parts/prepare-worker.sh

# binaries
. ${SCRIPTDIR}/parts/binaries-worker.sh

# docker
. ${SCRIPTDIR}/parts/docker.sh

# service 配置
. ${SCRIPTDIR}/parts/service-worker.sh

# kubelet
. ${SCRIPTDIR}/parts/kubelet.sh
. ${SCRIPTDIR}/parts/kubelet-worker.sh

# kube-proxy
. ${SCRIPTDIR}/parts/kube-proxy-worker.sh

kubectl get nodes
echo "==== You have joined the worker into cluster, use 'kubectl get nodes' to see detail ...  ===="
