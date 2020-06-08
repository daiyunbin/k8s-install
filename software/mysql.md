```bash

# 
helm install --name mysql --namespace mysql \
    --set imageTag=8.0.18 \
    --set persistence.size=20Gi \
    --set metrics.enabled=true \
    stable/mysql

MySQL can be accessed via port 3306 on the following DNS name from within your cluster:
mysql.mysql.svc.cluster.local

To get your root password run:

    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

To connect to your database:

1. Run an Ubuntu pod that you can use as a client:

    kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il

2. Install the mysql client:

    $ apt-get update && apt-get install mysql-client -y

3. Connect using the mysql cli, then provide your password:
    $ mysql -h mysql -p

To connect to your database directly from outside the K8s cluster:
    MYSQL_HOST=127.0.0.1
    MYSQL_PORT=3306

    # Execute the following command to route the connection:
    kubectl port-forward svc/mysql 3306

    mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}

# 将下面的配置加到 tcp-config.yaml 中
"3306": mysql/mysql:3306

# 连接时遇到如下问题
ERROR 2059 (HY000): Authentication plugin 'caching_sha2_password' cannot be loaded:

# 原因：MySQL8 版本默认的认证方式是caching_sha2_password，而在MySQL5.7版本则为mysql_native_password

# 解决方法
kubectl get pods -n mysql
kubectl exec mysql-asdffdsa -n mysql -it bash
mysql -u root -p
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Dp5VqJtAQr';

```