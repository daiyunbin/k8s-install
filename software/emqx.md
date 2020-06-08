
# helm3

helm repo add emqx https://repos.emqx.io/charts
helm repo update

helm install emqx --namespace emqx emqx/emqx --set persistence.enabled=true 


将下面的配置加到 tcp-config.yaml 中
"18083": emqx/emqx:18083
"1883": emqx/emqx:1883

后台：
http://10.136.11.199:18083