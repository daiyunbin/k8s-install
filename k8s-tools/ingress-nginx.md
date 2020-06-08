## Install Ingress-nginx

```bash
# 使用 daemon-set 的方式安装

# 在边缘节点安装 ingres-nginx-controller
kubectl label node k8s-m1 node-role.kubernetes.io/edge=
kubectl label node k8s-m2 node-role.kubernetes.io/edge=


kubectl apply -f ingress-nginx.yaml

# 在跑 keepalived 的两台master上修改 /etc/keepalived/check-apiserver.sh
# 增加如下命令 

curl --silent --max-time 2 http://localhost/ -o /dev/null || errorExit "Error GET http://localhost/"
if ip addr | grep -q 10.136.11.198; then
   curl --silent --max-time 2 http://10.136.11.198/ -o /dev/null || errorExit "Error GET http://10.136.11.198/"
fi

# 上面的 ip 改成对应的虚拟 ip
# 重启 keepalived 
systemctl restart keepalived
```

ingress-nginx 此处的设置是跑在主节点上的，主节点上 运行 keep-alived 保证服务的高可用。
主节点上若设置了入下的 taint, 其他任务的调度将不会运行在主节点上
kubectl taint nodes <node-name> node-role.kubernetes.io/master=:NoSchedule
kubectl taint nodes <node-name> node-role.kubernetes.io/master=:NoExecute


