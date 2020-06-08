mongodb 集群有三种部署方式：Replica Set，主从，分片，其中只有 分片的方式能够做到负载均衡

helm repo add bitnami https://charts.bitnami.com/bitnami
helm fetch bitnami/mongodb-sharded
tar zxvf mongodb-sharded-xxx.tgz
cd mongodb-sharded/
vim values.yaml
修改需要修改的参数
helm install mongodb -f values.yaml bitnami/mongodb-sharded --namespace mongodb


NOTES:
** Please be patient while the chart is being deployed **

The MongoDB Sharded cluster can be accessed via the Mongos instances in port 27017 on the following DNS name from within your cluster:

    mongodb-mongodb-sharded.mongodb.svc.cluster.local

To get the root password run:

    export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace mongodb mongodb-mongodb-sharded -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run --namespace mongodb mongodb-mongodb-sharded-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb-sharded:4.2.5-debian-10-r28 --command -- mongo admin --host mongodb-mongodb-sharded

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace mongodb svc/mongodb-mongodb-sharded 27017:27017 &
    mongo --host 127.0.0.1 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD