#!/bin/bash

# api-server证书和私钥
cd ${target}/pki/apiserver
cfssl gencert -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== api-server service ${MASTER_IP} ===="
  scp ${target}/pki/apiserver/kubernetes*.pem root@${MASTER_IP}:/etc/kubernetes/pki/
  ssh root@${MASTER_IP} "rm -rf /var/log/kubernetes; mkdir -p /var/log/kubernetes"
  scp ${target}/${MASTER_IP}/service-master/kube-apiserver.service root@${MASTER_IP}:/etc/systemd/system/

  if [ $MASTER_INDEX = 2 ]; then
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-apiserver && systemctl restart kube-apiserver"
  else
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-apiserver && systemctl restart kube-apiserver" &
  fi
done

# kube-apiserver status
checkStatus "kube-apiserver" 1