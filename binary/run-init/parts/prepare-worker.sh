#!/bin/bash

echo "==== preparing for k8s ${WORKER_IP} ===="
checkPrepare ${WORKER_IP} "prepare"
if [ $prepareResult = 0 ]; then
  ssh root@${WORKER_IP} < $SCRIPTDIR/parts/prepare-do.sh
  confirmPrepare ${WORKER_IP} "prepare"
fi