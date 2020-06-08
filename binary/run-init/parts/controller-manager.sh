#!/bin/bash

echo "==== deploy controller-manager ===="

# controller-manager证书和私钥
cd ${target}/pki/controller-manager
cfssl gencert -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes controller-manager-csr.json | cfssljson -bare controller-manager

# 创建kubeconfig
cd ${target}/pki/controller-manager
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --server=https://${kvs["MASTER_VIP"]}:6443 \
  --kubeconfig=controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=controller-manager.pem \
  --client-key=controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=controller-manager.kubeconfig

kubectl config set-context system:kube-controller-manager \
  --cluster=kubernetes \
  --user=system:kube-controller-manager \
  --kubeconfig=controller-manager.kubeconfig

kubectl config use-context system:kube-controller-manager --kubeconfig=controller-manager.kubeconfig

# 配置3台master
for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== controller-manager service ${MASTER_IP} ===="
  scp ${target}/pki/controller-manager/controller-manager*.pem root@${MASTER_IP}:/etc/kubernetes/pki/
  scp ${target}/pki/controller-manager/controller-manager.kubeconfig root@${MASTER_IP}:/etc/kubernetes/
  scp ${target}/${MASTER_IP}/service-master/kube-controller-manager.service root@${MASTER_IP}:/etc/systemd/system/

  if [ $MASTER_INDEX = 2 ]; then
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-controller-manager && systemctl restart kube-controller-manager"
  else
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-controller-manager && systemctl restart kube-controller-manager" &
  fi
done

# kube-controller-manager status
checkStatus "kube-controller-manager" 1
