#!/bin/bash

# 安装docker
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#yum remove -y docker*
yum install -y docker-ce-18.06.2.ce

# 配置目录
mkdir /etc/docker

cat <<EOF > /etc/docker/daemon.json
{
    "registry-mirrors": ["http://f1361db2.m.daocloud.io"],
    "insecure-registries": ["hub.cmtech-soft.com","hub.cmtech-soft-test.com","hub.cmtech-soft-local.com"]
}
EOF

# 启动docker服务
systemctl daemon-reload && systemctl enable docker && systemctl restart docker

exit
