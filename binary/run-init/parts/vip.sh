#!/bin/bash

# 使用虚拟ip,在0号1号master上设置虚拟ip
if [ ${kvs["USE_KEEPALIVED"]} = "1" ]; then
  for MASTER_INDEX in 0 1; do
    MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}
    echo "==== set keepalived ${MASTER_IP} ===="
    ssh root@${MASTER_IP} "systemctl stop keepalived; yum remove keepalived -y; systemctl daemon-reload"

    ssh root@${MASTER_IP} "rm -rf /etc/keepalived; mkdir -p /etc/keepalived; yum install -y keepalived"
    if [ $MASTER_INDEX = 0 ]; then
      scp ${target}/configs/keepalived-master.conf root@${MASTER_IP}:/etc/keepalived/keepalived.conf
    else
      scp ${target}/configs/keepalived-backup.conf root@${MASTER_IP}:/etc/keepalived/keepalived.conf
    fi
    scp ${target}/configs/check-apiserver.sh root@${MASTER_IP}:/etc/keepalived/
    ssh root@${MASTER_IP} "systemctl enable keepalived && systemctl restart keepalived"
    checkStatus "keepalived" 0 ${MASTER_IP}
  done
fi