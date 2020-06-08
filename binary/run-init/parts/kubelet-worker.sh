#!/bin/bash

# kubelet 配置文件
echo "==== Config kubelet ${WORKER_IP} ===="
scp ${target}/pki/admin/kubelet-bootstrap.kubeconfig root@${WORKER_IP}:/etc/kubernetes/kubelet-bootstrap.kubeconfig
scp ${target}/pki/ca.pem root@${WORKER_IP}:/etc/kubernetes/pki/
scp ${worker_target}/kubelet.config.json root@${WORKER_IP}:/etc/kubernetes/
scp ${worker_target}/kubelet.service root@${WORKER_IP}:/etc/systemd/system/
ssh root@${WORKER_IP} "rm -rf /var/lib/kubelet; rm -rf /var/log/kubernetes; mkdir -p /var/lib/kubelet; mkdir -p /var/log/kubernetes"

# 设置默认上下文
cd ${target}/pki/admin
kubectl config use-context default --kubeconfig=kubelet-bootstrap.kubeconfig

echo "==== Starting kubelet ${WORKER_IP} ===="
ssh root@${WORKER_IP} "systemctl daemon-reload"
ssh root@${WORKER_IP} "systemctl enable kubelet"
ssh root@${WORKER_IP} "systemctl restart kubelet"

checkStatus "kubelet" 0 ${WORKER_IP}

try=1
while true
do
  csr_str=$(echo `kubectl get csr`)
  csr_array=(${csr_str// / })
  found=0
  index=4
  while test $[found] -eq 0
  do
    if [[ -n "${csr_array[${index}]}" ]]; then
      if [[ "${csr_array[$[index+3]]}" = "Pending" ]]; then
        kubectl certificate approve ${csr_array[${index}]}
        echo "==== Worker node approved: ${csr_array[${index}]} ===="
        found=1
        break
      else
        index=$[index+4]
        continue
      fi
    else
      break
    fi
  done

  if test $[found] -eq 1
  then
    break
  else
    if test $[try] -lt 5
    then
      echo "==== Csr not found, wait 5 seconds to try again ===="
      try=$[try+1]
      sleep 5
    else
      if [[ ! ${yes_to_all} = "-y" ]]; then
        read -r -p "Worker node csr not found!. Continue to deploy? y to continue, others to exit. [y] " check_status
      else
        check_status="y"
      fi
      if [ ! $check_status ]; then
        check_status="y"
      fi
      if [ $check_status != "y" ]; then
        exit 1
      fi

      break
    fi
  fi
done