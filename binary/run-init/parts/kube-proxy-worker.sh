#!/bin/bash

echo "==== config and start kube-proxy ${WORKER_IP} ===="

# kube-proxy 配置文件
scp ${target}/pki/proxy/kube-proxy.kubeconfig root@${WORKER_IP}:/etc/kubernetes/
scp ${worker_target}/kube-proxy.config.yaml root@${WORKER_IP}:/etc/kubernetes/
scp ${worker_target}/kube-proxy.service root@${WORKER_IP}:/etc/systemd/system/

ssh root@${WORKER_IP} "rm -rf /var/lib/kube-proxy; rm -rf /var/log/kubernetes"
ssh root@${WORKER_IP} "mkdir -p /var/lib/kube-proxy; mkdir -p /var/log/kubernetes"

# 设置默认上下文
cd ${target}/pki/proxy
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

ssh root@${WORKER_IP} "systemctl daemon-reload && systemctl enable kube-proxy && systemctl restart kube-proxy"

checkStatus "kube-proxy" 0 ${WORKER_IP}