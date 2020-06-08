#!/bin/bash

echo "==== download k8s binaries ===="
if [ ! -d /root/k8s-binary ]; then
  mkdir -p /root/k8s-binary/master
  mkdir -p /root/k8s-binary/worker
  cd /root/k8s-binary/master
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/etcd
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/etcdctl
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/kube-apiserver
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/kube-controller-manager
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/kube-scheduler
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/kubeadm
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/master/kubectl
  chmod +x /root/k8s-binary/master/*

  cd /root/k8s-binary/worker
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/worker/kube-proxy
  wget http://tt.sophaur.com/k8s-binary/${kvs["K8S_VERSION"]}/worker/kubelet
  chmod +x /root/k8s-binary/worker/*
fi

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== dispatch k8s binaries ${MASTER_IP} ===="
  checkPrepare ${MASTER_IP} "binaries"
  if [ $prepareResult = 0 ]; then
    ssh root@${MASTER_IP} "rm -rf /opt/kubernetes/bin; mkdir -p /opt/kubernetes/bin"
    ssh root@${MASTER_IP} "sed -i /.*kubernetes.*/d ~/.bashrc; echo 'PATH=/opt/kubernetes/bin:$PATH' >>~/.bashrc; source ~/.bashrc"
    scp /root/k8s-binary/master/* root@${MASTER_IP}:/opt/kubernetes/bin/
    confirmPrepare ${MASTER_IP} "binaries"
  fi
done

# 部署节点命令生效
source ~/.bashrc