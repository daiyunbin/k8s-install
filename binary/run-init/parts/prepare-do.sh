#!/bin/bash

# exit when error
#set -o errexit

# 安装依赖包
yum install -y conntrack ipvsadm ipset jq sysstat curl iptables libseccomp epel-release wget yum-utils device-mapper-persistent-data lvm2 net-tools socat
# 启动系统模块
modprobe br_netfilter
modprobe ip_vs

# 关闭防火墙
systemctl stop firewalld && systemctl disable firewalld
# 重置iptables
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat && iptables -P FORWARD ACCEPT
# 关闭swap
swapoff -a
sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab
# 关闭selinux
setenforce 0
# 关闭dnsmasq(否则可能导致docker容器无法解析域名)
service dnsmasq stop && systemctl disable dnsmasq

# 制作配置文件
cat > /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
EOF
# 生效文件
sysctl -p /etc/sysctl.d/kubernetes.conf

exit