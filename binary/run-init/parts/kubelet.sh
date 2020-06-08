#!/bin/bash

echo "==== set kubelet config files ===="
#创建 token
cd ${target}/pki/admin
export BOOTSTRAP_TOKEN=$(kubeadm token create \
      --description kubelet-bootstrap-token \
      --groups system:bootstrappers:worker \
      --kubeconfig kube.config)
# 设置集群参数
kubectl config set-cluster kubernetes \
      --certificate-authority=../ca.pem \
      --embed-certs=true \
      --server=https://${kvs["MASTER_VIP"]}:6443 \
      --kubeconfig=kubelet-bootstrap.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
      --token=${BOOTSTRAP_TOKEN} \
      --kubeconfig=kubelet-bootstrap.kubeconfig
# 设置上下文参数
kubectl config set-context default \
      --cluster=kubernetes \
      --user=kubelet-bootstrap \
      --kubeconfig=kubelet-bootstrap.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=kubelet-bootstrap.kubeconfig
# bootstrap附权
kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --group=system:bootstrappers
