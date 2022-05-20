> 当前`k8s`集群版本`1.23.6`

### 1.1 添加 repo

```
[root@master helm]# helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

[root@master helm]# helm search repo kubernetes-dashboard/kubernetes-dashboard
NAME                                     	CHART VERSION	APP VERSION	DESCRIPTION                                   
kubernetes-dashboard/kubernetes-dashboard	5.4.1        	2.5.1      	General-purpose web UI for Kubernetes clusters
```

### 1.2 自定义配置文件 dashboard.yaml

```
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: 'true'
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  paths:
    - /
  hosts:
    - dashboard.xwz.com
  tls:
    - secretName: tls-secret
      hosts:
        - dashboard.xwz.com

# 让 dashboard 的权限够大，这样我们可以方便操作多个 namespace
rbac:
  clusterReadOnlyRole: true
```

> *   `rbac.clusterAdminRole=true`：让 `dashboard` 的权限够大，这样我们可以方便操作多个 `namespace`

### 1.3 安装

```
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
 -f dashboard.yaml --version 5.4.1 --namespace kube-system

# 卸载
helm uninstall kubernetes-dashboard -n kube-system
```

### 1.4 查看

```
[root@master kubernetes-dashboard]# kubectl get pods,svc,ingress -n kube-system | grep kubernetes-dashboard
pod/kubernetes-dashboard-776d78f47b-zk89d           1/1     Running   0             84s
service/kubernetes-dashboard                 ClusterIP   10.105.247.57   <none>        443/TCP                  84s
ingress.networking.k8s.io/kubernetes-dashboard   <none>   dashboard.wanfei.wang   10.0.1.27   80, 443   84s

```

访问 [dashboard.xwz.com](https://dashboard.xwz.com)  


### 1.5 查看 token

添加 sh 脚本

```
vi dashboard-token.sh

#!/bin/sh
TOKENS=$(kubectl describe serviceaccount kubernetes-dashboard -n kube-system | grep "Tokens:" | awk '{ print $2}')
kubectl describe secret $TOKENS -n kube-system | grep "token:" | awk '{ print $2}'

```

执行

```
sh dashboard-token.sh

```