#!/bin/bash

# 配置 Python 相关, 解决出现 ImportError: No module named pkg_resources
if [ ! -d /root/ceph-binary ]; then
  mkdir -p /root/ceph-binary && cd /root/ceph-binary
  wget https://pypi.python.org/packages/source/d/distribute/distribute-0.7.3.zip --no-check-certificate
fi

for MONITOR_INDEX in 0 1 2; do
  MONITOR_IP=${kvs["MONITOR_${MONITOR_INDEX}_IP"]}

  echo "==== preparing for ceph ${MONITOR_IP} ===="
  checkPrepare ${MONITOR_IP} "prepare-ceph"
  if [ $prepareResult = 0 ]; then
    scp /root/ceph-binary/distribute-0.7.3.zip root@${MONITOR_IP}:/usr/local/distribute-0.7.3.zip
    ssh root@${MONITOR_IP} < $SCRIPTDIR/parts/prepare-do.sh
    confirmPrepare ${MONITOR_IP} "prepare-ceph"
  fi
done