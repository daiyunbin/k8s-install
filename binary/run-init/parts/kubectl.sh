#!/bin/bash

# 在当前部署节点部署kubectl
echo "==== deploy kubectl ===="

# kubectl证书和私钥
cd ${target}/pki/admin
cfssl gencert -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes admin-csr.json | cfssljson -bare admin

# 设置集群参数
cd ${target}/pki/admin
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --server=https://${kvs["MASTER_VIP"]}:6443 \
  --kubeconfig=kube.config

# 设置客户端认证参数
kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem \
  --embed-certs=true \
  --kubeconfig=kube.config

# 设置上下文参数
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=kube.config

# 设置默认上下文
kubectl config use-context kubernetes --kubeconfig=kube.config

# 配置文件
rm -rf ~/.kube && mkdir ~/.kube
cp kube.config ~/.kube/config
# 授予 kubernetes 证书访问 kubelet API 的权限
kubectl create clusterrolebinding kube-apiserver:kubelet-apis --clusterrole=system:kubelet-api-admin --user kubernetes
# 查看集群信息
kubectl cluster-info
kubectl get all --all-namespaces
kubectl get componentstatuses

if [[ ! ${yes_to_all} = "-y" ]]; then
  read -r -p "Kubectl ready. Continue to deploy? y to continue, others to exit. [y] " check_status
else
  check_status="y"
fi
if [ ! $check_status ]; then
  check_status="y"
fi
if [ $check_status != "y" ]; then
  exit 1
fi