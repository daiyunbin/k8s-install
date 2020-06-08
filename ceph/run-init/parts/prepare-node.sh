#!/bin/bash

echo "==== preparing for ceph ${NODE_IP} ===="
checkPrepare ${NODE_IP} "prepare-ceph"
if [ $prepareResult = 0 ]; then
  scp /root/ceph-binary/distribute-0.7.3.zip root@${NODE_IP}:/usr/local/distribute-0.7.3.zip
  ssh root@${NODE_IP} < $SCRIPTDIR/parts/prepare-do.sh
  confirmPrepare ${NODE_IP} "prepare-ceph"
fi
