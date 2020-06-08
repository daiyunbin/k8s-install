#!/bin/bash

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== preparing for k8s ${MASTER_IP} ===="
  checkPrepare ${MASTER_IP} "prepare"
  if [ $prepareResult = 0 ]; then
    ssh root@${MASTER_IP} < $SCRIPTDIR/parts/prepare-do.sh
    confirmPrepare ${MASTER_IP} "prepare"
  fi
done