# Ceph 安装

Mimic 版本 是 LTS（长期维护稳定版）版本，使用该版本安装

> 注意：不能在安装了 k8s 的机器上安装，会覆盖掉 hosts 配置

https://docs.ceph.com/docs/master/releases/mimic/

1. 准备3台机器，CentOS系统，用作monitor节点，预先执行 yum update -y
2. 选择一台机器作为部署节点，配置部署节点到其他节点的免密 ssh 登录
```bash
ssh-keygen
ssh-copy-id root@192.168.193.130
ssh-copy-id root@192.168.193.131
ssh-copy-id root@192.168.193.132
```
3. 克隆项目到部署节点，编辑 config.properties 文件，配置相应的参数
4. 运行 init-monitors.sh 初始化集群和监控节点
5. 运行 ceph-deploy osd create --data /dev/sdb ceph-n2 命令增加相应的osd
6. 当有新节点加入时，运行 init-node.sh



安装 cephfs
1. 在部署目录中，此处 /root/ceph-install-target，运行如下命令
ceph-deploy --overwrite-conf mds create ceph-test-m1 ceph-test-m2 ceph-test-m3

2. ceph osd pool create fs_data 1024
   ceph osd pool create fs_metadata 128
   ceph fs new cephfs fs_metadata fs_data