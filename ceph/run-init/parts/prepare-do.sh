#!/bin/bash

# 配置yum源
cat > /etc/yum.repos.d/ceph.repo <<EOF
[Ceph]
name=Ceph packages for $basearch
baseurl=https://mirrors.aliyun.com/ceph/rpm-mimic/el7/x86_64/
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[Ceph-noarch]
name=Ceph noarch packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-mimic/el7/noarch/
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-mimic/el7/SRPMS/
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
EOF

# 安装 ceph-deploy
yum install -y ceph-deploy ntp ntpdate ntp-doc unzip wget

# 关闭防火墙和selinux
systemctl stop firewalld.service
systemctl disable firewalld.service
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

cd /usr/local && rm -rf distribute-0.7.3 && unzip distribute-0.7.3.zip
rm -f distribute-0.7.3.zip && cd distribute-0.7.3 && python setup.py install

exit