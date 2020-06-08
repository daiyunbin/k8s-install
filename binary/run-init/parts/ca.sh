#!/bin/bash

echo "==== install ca tools ===="
if [ ! -e /root/bin/cfssl ]; then
  mkdir -p /root/bin
  wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O /root/bin/cfssl
  wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O /root/bin/cfssljson
  chmod +x /root/bin/cfssl /root/bin/cfssljson
fi
cfssl version

echo "==== generate ca certificate ===="
cp -r ${SCRIPTDIR}/../pki ${target}
replace_files ${target}/pki

# 生成根证书和私钥
cd ${target}/pki
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

for MASTER_INDEX in 0 1 2; do
  MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}

  # 拷贝根证书
  ssh root@${MASTER_IP} "rm -rf /etc/kubernetes/pki/; mkdir -p /etc/kubernetes/pki/"
  scp ${target}/pki/ca*.pem root@${MASTER_IP}:/etc/kubernetes/pki/
done



