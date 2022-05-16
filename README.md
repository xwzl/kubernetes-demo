# 1. 部署 ingress 

```shell
# 启用 ingress
minikube addons enable ingress
# 禁用 ingress
minikube addons disable ingress

# 或者部署 yaml/service/ingress-deploy.yaml ingress
kubectl apply -f ingress-deploy.yaml
```

# 2. 通过 ingress 访问服务

部署服务
    
    kubectl apply -f app.yaml

```shell
# 端口
kubectl get all -n ingress-nginx    
# 本地监听端口:8000
# 容器端口:80
kubectl port-forward service/ingress-nginx-controller 8000:80 -n ingress-nginx

# 或者在 k8s 容器中执行一下命令,ip 为 pod/ingress-nginx-controller IP 地址
echo "172.17.0.2 tomcat.cnsre.cn" >> /etc/hosts
echo "172.17.0.2 nginx1.com" >> /etc/hosts

curl nginx1.com
```

