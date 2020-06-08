#!/bin/bash

# exit when error
#set -o errexit

# 替换文件中的参数配置
function replace_files() {
    local file=$1
    if [ -f $file ];then
        echo "$file"
        for key in ${!kvs[@]}
        do
            value=${kvs[$key]}
            value=${value//\//\\\/}
            sed -i "s/{{$key}}/${value}/g" $file
        done
        return 0
    fi
    if [ -d $file ];then
        for f in `ls $file`
        do
            replace_files "${file}/${f}"
        done
    fi
    return 0
}

# 初始化 参数列表
function initKvs() {
  local configFile=$1
  while read line;do
    if [ "${line:0:1}" == "#" -o "${line:0:1}" == "" ];then
        continue;
    fi
    key=${line/=*/}
    value=${line#*=}
    echo "$key=$value"
    kvs["$key"]="$value"
  done < $configFile
  return 0
}

# 获取脚本所在目录
function getScriptDir() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "${SOURCE}" ]; do
    SCRIPTDIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null && pwd)"
    SOURCE="$(readlink "${SOURCE}")"
    [[ ${SOURCE} != /* ]] && SOURCE="${SCRIPTDIR}/${SOURCE}"
  done
  SCRIPTDIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null && pwd)"
  echo script dir: ${SCRIPTDIR}
  return 0
}

function doCheck() {
  local serviceName=$1
  local masterCheck=$2
  local nodeIp=$3

  if [ $masterCheck = 1 ]; then
    for MASTER_INDEX in 0 1 2; do
      MASTER_IP=${kvs["MASTER_${MASTER_INDEX}_IP"]}
      echo "==== ${serviceName} service status ${MASTER_IP} ===="
      ssh root@${MASTER_IP} "systemctl status ${serviceName}"
    done
  else
    echo "==== ${serviceName} service status ${nodeIp} ===="
    ssh root@${nodeIp} "systemctl status ${serviceName}"
  fi

  # 是否继续部署
  if [[ ! ${yes_to_all} = "-y" ]]; then
    read -r -p "continue to deploy? y to continue, n to check status again, others to exit. [y] " check_status
  else
    check_status="y"
  fi
  if [ ! $check_status ]; then
    check_status="y"
  fi
  if [ $check_status = "y" ]; then
    return 0
  elif [ $check_status = "n" ]; then
    doCheck $serviceName $masterCheck $nodeIp
  else
    exit 1
  fi
}

# 查询service状态
function checkStatus() {
  local serviceName=$1
  local masterCheck=$2
  local nodeIp=$3
  if [[ ! ${yes_to_all} = "-y" ]]; then
    read -r -p "${serviceName} service has deployed, check status? [y] " check_status
  else
    check_status="y"
  fi
  if [ ! $check_status ]; then
    check_status="y"
  fi
  if [ $check_status = "y" ]; then
    doCheck $serviceName $masterCheck $nodeIp
  fi
}

# 检查是否做过初始化准备工作
function checkPrepare() {
  local nodeIp=$1
  local checkType=$2
  if ssh root@${nodeIp} test -e /root/k8s-check/${checkType}
  then
    prepareResult=1
  else
    prepareResult=0
  fi
}
function confirmPrepare() {
  local nodeIp=$1
  local checkType=$2
  ssh root@${nodeIp} "mkdir -p /root/k8s-check; touch /root/k8s-check/${checkType}"
}
