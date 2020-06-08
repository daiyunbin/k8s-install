#!/bin/bash

cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${kvs["MASTER_0_IP"]} ${kvs["MASTER_0_HOSTNAME"]}
${kvs["MASTER_1_IP"]} ${kvs["MASTER_1_HOSTNAME"]}
${kvs["MASTER_2_IP"]} ${kvs["MASTER_2_HOSTNAME"]}
EOF

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}
  MASTER_HOSTNAME=${kvs["MASTER_${MASTER_INDEX}_HOSTNAME"]}

  echo "==== set hostname ${MASTER_IP} ===="
  ssh root@${MASTER_IP} "hostnamectl set-hostname ${MASTER_HOSTNAME}"

  echo "==== seting hosts ${MASTER_IP} ===="
  scp /etc/hosts root@${MASTER_IP}:/etc/hosts
done