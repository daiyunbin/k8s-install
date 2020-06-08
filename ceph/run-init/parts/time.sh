#!/bin/bash

# 设置时间同步

for MONITOR_INDEX in 0 1 2; do
  MONITOR_IP=${kvs["MONITOR_${MONITOR_INDEX}_IP"]}

  ssh root@${MONITOR_IP} "sed -i 's/^server 0.centos.pool.ntp.org iburst$/server time1.aliyun.com minpoll 3 maxpoll 4 iburst/g' /etc/ntp.conf"
  ssh root@${MONITOR_IP} "sed -i 's/^server 1.centos.pool.ntp.org iburst$/server time2.aliyun.com minpoll 3 maxpoll 4 iburst/g' /etc/ntp.conf"
  ssh root@${MONITOR_IP} "sed -i 's/^server 2.centos.pool.ntp.org iburst$/server time3.aliyun.com minpoll 3 maxpoll 4 iburst/g' /etc/ntp.conf"
  ssh root@${MONITOR_IP} "sed -i 's/^server 3.centos.pool.ntp.org iburst$/server time4.aliyun.com minpoll 3 maxpoll 4 iburst/g' /etc/ntp.conf"
  ssh root@${MONITOR_IP} "systemctl enable ntpd.service && systemctl restart ntpd.service"
  sleep 5
  ssh root@${MONITOR_IP} "ntpq -pn"
done