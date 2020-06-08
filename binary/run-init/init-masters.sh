#!/bin/bash

# exit when error
#set -o errexit

# 部署配置目录
target="/root/k8s-install-target"

# 是否强制重新部署
if [[ -n "$1" ]] && [[ "$1" -eq "1" ]]; then
  echo "force deployment!!!"
  rm -rf ${target}
fi
if [ -e ${target} ]; then
  echo "the masters has been initailized!!!"
  exit 1
fi
mkdir ${target}

# 所有判断是yes
yes_to_all=$2

# 替换变量的列表
declare -A kvs=()
declare -x SCRIPTDIR=''

# 引进使用的函数
. ./funcs.sh

# 获取脚本路径
getScriptDir

echo "==== 设置替换变量的列表 ===="
initKvs ${SCRIPTDIR}/../config.properties

# 设置部署节点 hosts
. ${SCRIPTDIR}/parts/hosts.sh

# 设置k8s相关环境
. ${SCRIPTDIR}/parts/prepare.sh

# 下载准备二进制文件
. ${SCRIPTDIR}/parts/binaries.sh

# service基本配置
. ${SCRIPTDIR}/parts/service.sh

# 证书工具
. ${SCRIPTDIR}/parts/ca.sh

# 虚拟ip
. ${SCRIPTDIR}/parts/vip.sh

# etcd
. ${SCRIPTDIR}/parts/etcd.sh

# api-server
. ${SCRIPTDIR}/parts/api-server.sh

# kubectl
. ${SCRIPTDIR}/parts/kubectl.sh

# controller-manager
. ${SCRIPTDIR}/parts/controller-manager.sh

# scheduler
. ${SCRIPTDIR}/parts/scheduler.sh

# kubelet
. ${SCRIPTDIR}/parts/kubelet.sh

# kube-proxy
. ${SCRIPTDIR}/parts/kube-proxy.sh

# calico
kubectl apply -f ${target}/configs/calico.yaml

# coredns
kubectl create -f ${target}/configs/coredns.yaml

# master-workers
. ${SCRIPTDIR}/parts/master-workers.sh

# 查看集群信息
kubectl cluster-info
kubectl get componentstatuses
echo "==== You have deployed k8s masters cluster ...  ===="



