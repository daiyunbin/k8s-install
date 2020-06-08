#!/bin/bash

echo "==== service config ===="

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}
  MASTER_HOSTNAME=${kvs["MASTER_${MASTER_INDEX}_HOSTNAME"]}

  echo "==== generate service config ${MASTER_IP} ===="
  mkdir -p ${target}/${MASTER_IP}
  cp -r ${SCRIPTDIR}/../service-master ${target}/${MASTER_IP}
  kvs["NODE_IP"]=${MASTER_IP}
  kvs["NODE_NAME"]=${MASTER_HOSTNAME}
  replace_files ${target}/${MASTER_IP}
done

cp -r ${SCRIPTDIR}/../configs ${target}
replace_files ${target}/configs