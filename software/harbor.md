```bash

# 安装 harbor 之前，先安装 postgreSql 和 redis, 参考 前面相关文章
# 使用 默认的 StorageClass

# 下载 chart
helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar

# harbor 的官方 charts repo 暂时不可用，使用 本地安装

git clone https://github.com/goharbor/harbor-helm.git
cd harbor-helm
git checkout v1.2.3

# 修改 values.yaml
# 设置 tls.enabled 为 false, 使用 http 访问仓库，注意在 docker配置中，
# /etc/docker/daemon.json 中 insecure-registries 要包含下面配置的域名
# 修改域名

# database 使用 external, 设置相关数据库连接参数
# 在外置数据库中 新建相关的 database

# redis 使用 external, 设置 Redis 相关连接参数


helm install --name harbor --namespace harbor . -f values.yaml

# 更改参数之后，使用下面命令更新
helm upgrade my-harbor . -f values.yaml
# 更新可能会出问题，直接删除重建

```