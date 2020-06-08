```bash

# helm install 
helm install --name consul --namespace consul stable/consul

# 将下面的配置加到 tcp-config.yaml 中
"8500": consul/consul:8500

```