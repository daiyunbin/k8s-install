#!/bin/bash

# etcd证书和私钥
cd ${target}/pki/etcd
cfssl gencert -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes etcd-csr.json | cfssljson -bare etcd

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  echo "==== etcd service ${MASTER_IP} ===="
  scp ${target}/pki/etcd/etcd*.pem root@${MASTER_IP}:/etc/kubernetes/pki/
  scp ${target}/${MASTER_IP}/service-master/etcd.service root@${MASTER_IP}:/etc/systemd/system/
  ssh root@${MASTER_IP} "rm -rf /var/lib/etcd; mkdir -p /var/lib/etcd"

  if [ $MASTER_INDEX = 2 ]; then
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable etcd && systemctl restart etcd"
  else
    ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable etcd && systemctl restart etcd" &
  fi
done

# etcd status
checkStatus "etcd" 1