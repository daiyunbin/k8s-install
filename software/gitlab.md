
```bash
# postgressql 使用 10 版本

# 1. 创建相关配置,修改对应的数据库地址
kubectl create configmap gitlab-config \
  --from-literal=postgres-host=192.168.193.145 \
  --from-literal=postgres-port=5431 \
  --from-literal=root-email=kai_meng@sina.cn \
  -n gitlab

# 2. 创建 password secret，修改对应的数据库密码，设置gitlab root密码
kubectl create secret generic gitlab-password \
  --from-literal=postgres-password=3J8KoOycb5 \
  --from-literal=root-password=Gitlab12345 \
  -n gitlab

# 3. 修改 gitlab.yaml 中的域名

# 4. 在数据库中增加 database gitlab

# 5. 将下面的配置加到 tcp-config.yaml 中
"1022": gitlab/gitlab:22

# 新用户初始密码 Cmtech12345

```
