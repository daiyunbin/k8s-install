
```bash
helm install --name redis --namespace redis stable/redis -f redis-production.yml


Redis can be accessed via port 6379 on the following DNS names from within your cluster:

redis-master.redis.svc.cluster.local for read/write operations
redis-slave.redis.svc.cluster.local for read-only operations


To get your password run:

    export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis -o jsonpath="{.data.redis-password}" | base64 --decode)

To connect to your Redis server:

1. Run a Redis pod that you can use as a client:

   kubectl run --namespace redis redis-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \--labels="redis-client=true" \
   --image docker.io/bitnami/redis:5.0.7-debian-9-r12 -- bash

2. Connect using the Redis CLI:
   redis-cli -h redis-master -a $REDIS_PASSWORD
   redis-cli -h redis-slave -a $REDIS_PASSWORD


Note: Since NetworkPolicy is enabled, only pods with label
redis-client=true"
will be able to connect to redis.


# 将下面的配置加到 tcp-config.yaml 中
"6379": redis/redis-master:6379
"6378": redis/redis-slave:6379
```