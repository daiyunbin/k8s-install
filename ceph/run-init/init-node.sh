#!/bin/bash

# exit when error
set -o errexit

# 部署配置目录
target="/root/ceph-install-target"

# 所有判断是yes
yes_to_all=$1

if [ ! -e ${target} ]; then
  echo "the monitors has not been initailized!!!"
  exit 1
fi

read -r -p "please input ceph node ip [192.168.193.133] " NODE_IP
if [ ! -n "${NODE_IP}" ] ;then
    echo "please input ceph node ip"
    exit 1
fi

read -r -p "please input ceph node hostname [ceph-n1] " NODE_HOSTNAME
if [ ! -n "${NODE_HOSTNAME}" ] ;then
    echo "please input ceph node hostname"
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

# 设置hosts
. ${SCRIPTDIR}/parts/hosts-sync.sh

# prepare
. ${SCRIPTDIR}/parts/prepare-node.sh

# time
. ${SCRIPTDIR}/parts/time-node.sh

# intall ceph packages
ceph-deploy install ${NODE_HOSTNAME}

echo "==== You have initailized the node for ceph cluster ===="
echo "==== Run follow command to add osd (Change /dev/sdb and ceph-n2) ===="
echo "==== cd /root/ceph-install-target ===="
echo "==== ceph-deploy osd create --data /dev/sdb ceph-n2 ===="



