helm install --name rabbitmq --namespace rabbit \
  --set image.tag=3.8.2-alpine \
  --set persistentVolume.enabled=true \
  --set persistentVolume.size=16Gi \
  stable/rabbitmq-ha

Credentials:

    Username            : guest
    Password            : $(kubectl get secret --namespace rabbit rabbitmq-rabbitmq-ha -o jsonpath="{.data.rabbitmq-password}" | base64 --decode)
    Management username : management
    Management password : $(kubectl get secret --namespace rabbit rabbitmq-rabbitmq-ha -o jsonpath="{.data.rabbitmq-management-password}" | base64 --decode)
    ErLang Cookie       : $(kubectl get secret --namespace rabbit rabbitmq-rabbitmq-ha -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)

  RabbitMQ can be accessed within the cluster on port 5672 at rabbitmq-rabbitmq-ha.rabbit.svc.cluster.local

  To access the cluster externally execute the following commands:

    export POD_NAME=$(kubectl get pods --namespace rabbit -l "app=rabbitmq-ha" -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME --namespace rabbit 5672:5672 15672:15672

  To Access the RabbitMQ AMQP port:

    amqp://127.0.0.1:5672/

  To Access the RabbitMQ Management interface:

    URL : http://127.0.0.1:15672


# 将下面的配置加到 tcp-config.yaml 中
"5672": rabbit/rabbitmq-rabbitmq-ha:5672
"15672": rabbit/rabbitmq-rabbitmq-ha:15672