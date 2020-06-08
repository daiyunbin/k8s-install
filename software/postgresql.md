
安装 10.x 版本，为gitlab 使用
```bash
helm install --name postgresql10 --namespace postgresql stable/postgresql -f postgresql-production.yml

PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:

    postgresql10.postgresql.svc.cluster.local - Read/Write connection
    postgresql10-read.postgresql.svc.cluster.local - Read only connection

To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgresql postgresql10 -o jsonpath="{.data.postgresql-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run postgresql10-client --rm --tty -i --restart='Never' --namespace postgresql --image docker.io/bitnami/postgresql:10.11.0-debian-9-r22 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql10 -U postgres -d postgres -p 5432



To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace postgresql svc/postgresql10 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432

# 将下面的配置加到 tcp-config.yaml 中
"5432": postgresql/postgresql10:5432
"5431": postgresql/postgresql10-read:5432

```
