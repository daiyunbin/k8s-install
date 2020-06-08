#!/bin/bash

# 删除hosts 当中已有的配置
echo "==== set hosts and hostname ===="

# 修改增加本地 hosts
ipreg=/^${WORKER_IP}.*/d
sed -i $ipreg /etc/hosts
hnreg=/.*${WORKER_HOSTNAME}$/d
sed -i $hnreg /etc/hosts
echo "${WORKER_IP} ${WORKER_HOSTNAME}" >> /etc/hosts

# 修改工作节点hostname
ssh root@${WORKER_IP} "hostnamectl set-hostname ${WORKER_HOSTNAME}"

# 同步 hosts 到各个节点
cat /etc/hosts | while read hostline
do
  hostarray=(${hostline// / })
  hostn=${hostarray[1]}
  hostip=${hostarray[0]}
  if [[ $hostn == k8s-* || $hostn == gluster-* || $hostn == ceph-* ]]; then
    echo "sysc hosts ... $hostip"
    scp /etc/hosts root@$hostip:/etc/hosts
  fi
done