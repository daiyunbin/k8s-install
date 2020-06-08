#!/bin/bash

cd ${target}

# init
ceph-deploy new ${kvs["MONITOR_0_HOSTNAME"]} ${kvs["MONITOR_1_HOSTNAME"]} ${kvs["MONITOR_2_HOSTNAME"]}

# 安装 ceph 软件包
ceph-deploy install ${kvs["MONITOR_0_HOSTNAME"]} ${kvs["MONITOR_1_HOSTNAME"]} ${kvs["MONITOR_2_HOSTNAME"]}

# Deploy the initial monitor(s) and gather the keys:
ceph-deploy mon create-initial

# copy the configuration file and admin key to your admin node and your Ceph Nodes
ceph-deploy admin ${kvs["MONITOR_0_HOSTNAME"]} ${kvs["MONITOR_1_HOSTNAME"]} ${kvs["MONITOR_2_HOSTNAME"]}

# Deploy a manager daemon
ceph-deploy mgr create ${kvs["MONITOR_0_HOSTNAME"]}

# 对象存储
ceph-deploy rgw create ${kvs["MONITOR_0_HOSTNAME"]}