https://hub.helm.sh/charts/bitnami/influxdb

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install influxdb bitnami/influxdb \
  --namespace influxdb \
  --set persistence.enabled=true \
  --set persistence.size=200Gi
  
### 不要使用 influxdb 集群版本，有巨坑
  --set architecture=high-availability \
  --set influxdb.replicaCount=3 \
  --set relay.replicaCount=2 \
  --set metrics.enabled=true
              
      
将下面的配置加到 tcp-services 中
"8086": influxdb/influxdb:8086
"9096": influxdb/influxdb-relay:9096

InfluxDB can be accessed through following DNS names from within your cluster:
    InfluxDB Relay (write operations): influxdb-relay.influxdb.svc.cluster.local (port 9096)
    InfluxDB servers (read operations):  influxdb.influxdb.svc.cluster.local (port 8086)
    InfluxDB Prometheus Metrics: influxdb-metrics.influxdb.svc.cluster.local (port 9122)

To get the password for the admin user, run:

    export ADMIN_PASSWORD=$(kubectl get secret --namespace influxdb influxdb -o jsonpath="{.data.admin-user-password}" | base64 --decode)

To connect to your database run the following commands:

    (write operations):

    kubectl run influxdb-client --rm --tty -i --restart='Never' --namespace influxdb --env="INFLUX_USERNAME=admin" --env="INFLUX_PASSWORD=$ADMIN_PASSWORD" \
        --image docker.io/bitnami/influxdb:1.8.0-debian-10-r1 \
        --command -- influx -host influxdb-relay -port 9096
        
    kubectl run influxdb-client --rm --tty -i --restart='Never' --namespace influxdb --env="INFLUX_USERNAME=admin" --env="INFLUX_PASSWORD=$ADMIN_PASSWORD" \
            --image docker.io/bitnami/influxdb:1.8.0-debian-10-r1 \
            --command -- influx -version

    (read operations):

    kubectl run influxdb-client --rm --tty -i --restart='Never' --namespace influxdb --env="INFLUX_USERNAME=admin" --env="INFLUX_PASSWORD=$ADMIN_PASSWORD" \
        --image docker.io/bitnami/influxdb:1.8.0-debian-10-r1 \
        --command -- influx -host influxdb -port 8086

To connect to your database from outside the cluster execute the following commands:

  (write operations):

    kubectl port-forward svc/influxdb-relay 9096:9096 &INFLUX_USERNAME="admin" INFLUX_PASSWORD="$ADMIN_PASSWORD" influx -host 127.0.0.1 -port 9096

  (read operations):

    kubectl port-forward svc/influxdb 8086:8086 &INFLUX_USERNAME="admin" INFLUX_PASSWORD="$ADMIN_PASSWORD" influx -host 127.0.0.1 -port 8086

可视化管理
helm install chronograf influxdata/chronograf --namespace influxdb

Chronograf can be accessed via port 80 on the following DNS name from within your cluster:

- http://chronograf-chronograf.influxdb

You can easily connect to the remote instance from your browser. Forward the webserver port to localhost:8888

- kubectl port-forward --namespace influxdb $(kubectl get pods --namespace influxdb -l app=chronograf-chronograf -o jsonpath='{ .items[0].metadata.name }') 8888

You can also connect to the container running Chronograf. To open a shell session in the pod run the following:

- kubectl exec -i -t --namespace influxdb $(kubectl get pods --namespace influxdb -l app=chronograf-chronograf -o jsonpath='{.items[0].metadata.name}') /bin/sh

To trail the logs for the Chronograf pod run the following:

- kubectl logs -f --namespace influxdb $(kubectl get pods --namespace influxdb -l app=chronograf-chronograf -o jsonpath='{ .items[0].metadata.name }')