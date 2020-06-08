#!/bin/bash

cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${kvs["MONITOR_0_IP"]} ${kvs["MONITOR_0_HOSTNAME"]}
${kvs["MONITOR_1_IP"]} ${kvs["MONITOR_1_HOSTNAME"]}
${kvs["MONITOR_2_IP"]} ${kvs["MONITOR_2_HOSTNAME"]}
EOF

for MONITOR_INDEX in 0 1 2; do
  MONITOR_IP=${kvs["MONITOR_${MONITOR_INDEX}_IP"]}
  MONITOR_HOSTNAME=${kvs["MONITOR_${MONITOR_INDEX}_HOSTNAME"]}

  echo "==== set hostname ${MONITOR_IP} ===="
  ssh root@${MONITOR_IP} "hostnamectl set-hostname ${MONITOR_HOSTNAME}"

  echo "==== seting hosts ${MONITOR_IP} ===="
  scp /etc/hosts root@${MONITOR_IP}:/etc/hosts
done