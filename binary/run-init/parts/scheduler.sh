#!/bin/bash

echo "==== deploy scheduler ===="

# scheduler证书和私钥
cd ${target}/pki/scheduler
cfssl gencert -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes scheduler-csr.json | cfssljson -bare kube-scheduler

kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --server=https://${kvs["MASTER_VIP"]}:6443 \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=kube-scheduler.pem \
  --client-key=kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context system:kube-scheduler \
  --cluster=kubernetes \
  --user=system:kube-scheduler \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig

# 配置3台master
for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== scheduler service ${MASTER_IP} ===="
  scp ${target}/pki/scheduler/kube-scheduler.kubeconfig root@${MASTER_IP}:/etc/kubernetes/
  scp ${target}/${MASTER_IP}/service-master/kube-scheduler.service root@${MASTER_IP}:/etc/systemd/system/

  if [ $MASTER_INDEX = 2 ]; then
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-scheduler && systemctl restart kube-scheduler"
  else
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-scheduler && systemctl restart kube-scheduler" &
  fi
done

# kube-scheduler status
checkStatus "kube-scheduler" 1