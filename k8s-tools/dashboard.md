## Install Kubernetes dashboard

记得更改 hosts

```bash
# helm 3
helm install kubernetes-dashboard stable/kubernetes-dashboard --namespace kube-system -f dashboard.yaml

# helm 2
helm install stable/kubernetes-dashboard -n kubernetes-dashboard --namespace kube-system \
  --set=enableSkipLogin=true -f dashboard.yaml
```