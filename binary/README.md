# 二进制方式安装K8s

### 从虚拟机中安装，需要设置静态ip
vi /etc/sysconfig/network-scripts/ifcfg-ens33

BOOTPROTO="dhcp" 改成 "static"
增加：
IPADDR=192.168.6.181
NETMASK=255.255.255.0
GATEWAY=192.168.6.2
DNS1=192.168.6.2
###

该安装方式安装的是高可用的K8s集群，包含3台master节点及若干worker节点

小版本号选择5以后的版本，当前选择 1.15.6

1. 准备3台机器，CentOS系统，用作master节点，预先执行 yum update -y
2. 选择一台机器作为部署节点，配置部署节点到其他节点的免密 ssh 登录
```bash
ssh-keygen
ssh-copy-id root@192.168.193.145
ssh-copy-id root@192.168.193.146
ssh-copy-id root@192.168.193.147
```
3. 克隆项目到部署节点，编辑 config.properties 文件，配置相应的参数
4. 进入 run-init 文件夹 cd run-init
5. 运行 ./init-masters.sh 初始化 master节点，创建集群。增加参数1会进行覆盖安装
6. 运行 ./init-worker.sh 初始化 worker 节点，加入集群


### 注意
在新增 worker 节点后，别忘记在 worker 节点上安装 ceph-common, 参照 ceph-for-k8s.md

### 常见问题
1. etcd 无法启动
