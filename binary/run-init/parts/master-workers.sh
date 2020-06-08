#!/bin/bash

# 让 master 节点也成为可以用于调度的节点

if [[ ${kvs["MASTER_WORKERS"]} = "1" ]]; then
  echo "==== Make master nodes workers ===="

  for MASTER_INDEX in 0 1 2; do
    WORKER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}
    WORKER_HOSTNAME=${kvs["MASTER_${MASTER_INDEX}_HOSTNAME"]}

    worker_target=${target}/worker-${WORKER_IP}

    # binaries
    . ${SCRIPTDIR}/parts/binaries-worker.sh

    # docker
    . ${SCRIPTDIR}/parts/docker.sh

    # service 配置
    . ${SCRIPTDIR}/parts/service-worker.sh

    # kubelet
    . ${SCRIPTDIR}/parts/kubelet-worker.sh

    # kube-proxy
    . ${SCRIPTDIR}/parts/kube-proxy-worker.sh
  done

  sleep 10
  for MASTER_INDEX in 0 1 2; do
    WORKER_HOSTNAME=${kvs["MASTER_${MASTER_INDEX}_HOSTNAME"]}
    kubectl label node ${WORKER_HOSTNAME} node-role.kubernetes.io/master=
  done

  echo "Use 'kubectl get nodes' to see detail ...  ===="
fi

