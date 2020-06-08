## Install Helm

```bash
# HELM 3
# install helm
mkdir /root/k8s-tools && cd /root/k8s-tools
wget http://tt.sophaur.com/helm/helm-v3.0.0-linux-amd64.tar.gz
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

# HELM 2
wget http://tt.sophaur.com/helm/helm-v2.16.1-linux-amd64.tar.gz
tar -zxvf helm-v2.16.1-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
# tiller
kubectl create -f helm-rbac.yaml
# tiller image
docker pull registry.cn-shanghai.aliyuncs.com/k8s-meng/tiller:v2.16.1
docker tag registry.cn-shanghai.aliyuncs.com/k8s-meng/tiller:v2.16.1 gcr.io/kubernetes-helm/tiller:v2.16.1
docker rmi registry.cn-shanghai.aliyuncs.com/k8s-meng/tiller:v2.16.1
helm init --service-account tiller --skip-refresh

# initialize helm
helm repo add stable http://mirror.azure.cn/kubernetes/charts
helm repo list
helm repo update
```

使用国内镜像
https://charts.ost.ai/

helm 升级
https://blog.csdn.net/Man_In_The_Night/article/details/104798513

wget http://tt.sophaur.com/helm/helm-v3.1.2-linux-amd64.tar.gz

helm init --upgrade --stable-repo-url https://charts.ost.ai/ --tiller-image jessestuart/tiller:v2.16.5 --service-account tiller