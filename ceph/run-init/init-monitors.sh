#!/bin/bash

# exit when error
set -o errexit

# 部署配置目录
target="/root/ceph-install-target"

# 是否强制重新部署
if [[ -n "$1" ]] && [[ "$1" -eq "1" ]]; then
  echo "force deployment!!!"
  rm -rf ${target}
fi
if [ -e ${target} ]; then
  echo "the monitors has been initailized!!!"
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

# hosts
. ${SCRIPTDIR}/parts/hosts.sh

# prepare
. ${SCRIPTDIR}/parts/prepare.sh

# time
. ${SCRIPTDIR}/parts/time.sh

# deploy
. ${SCRIPTDIR}/parts/deploy.sh

# 查看集群信息
ceph -s
echo "==== You have deployed ceph monitors cluster ...  ===="
echo "==== Run follow command to add osd (Change /dev/sdb and ceph-n2) ===="
echo "==== cd /root/ceph-install-target ===="
echo "==== ceph-deploy osd create --data /dev/sdb ceph-n2 ===="



