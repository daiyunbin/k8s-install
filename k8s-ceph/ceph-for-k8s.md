```bash
# 在k8s集群中所有Worker节点安装 ceph-common
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

# 安装 ceph-common
yum install -y ceph-common

# 创建 osd pool
ceph osd pool create kube 256

# 创建 kube用户
ceph auth get-or-create client.kube mon 'allow r' osd 'allow *'

# 获取用户key
ceph auth get-key client.admin|base64
ceph auth get-key client.kube|base64

1. 使用上面的 key 替换 rbd-dynamic.yaml 中的key
2. 修改 StorageClass 的 monitors

# 创建并查看 pvc
kubectl apply -f rbd-dynamic.yaml
kubectl get pvc


```