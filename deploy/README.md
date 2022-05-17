# 1. 安装 K8S

自动化部署脚本 https://github.com/lework/kainstall

## 1.1 yum 源中可能找不到 sshpass ,手动安装

```xshell
wget https://nchc.dl.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz

tar zxf sshpass-1.06.tar.gz

cd sshpass-1.06

./configure --prefix=/usr/local/

make && make install
```

## 1.2 安装 k8s

```shell
# 下载脚本
wget https://cdn.jsdelivr.net/gh/lework/kainstall@master/kainstall-centos.sh

# Node not ready,下载不下来需要手动下载 yaml 文件
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

# 2 部署 ingress

## 2.1 安装 ingress

依照 k8s 脚本安装合适的 ingress nginx 脚本

https://github.com/kubernetes/ingress-nginx/tree/main/deploy/static/provider/baremetal

国外源下载不下来，https://cr.console.aliyun.com/cn-hangzhou/instances/images?accounttraceid=77f6797a00534741a43f440f46eeb106tkhk 替换镜像源



## 2.2 minikube 安装方式

```shell
# 启用 ingress
minikube addons enable ingress
# 禁用 ingress
minikube addons disable ingress
```

## 2.3 手动搭建

```shell
# 或者部署 yaml/service/ingress-deploy.yaml ingress
kubectl apply -f /yaml/service/ingress-deploy.yaml

# 查看 ingress-nginx 资源
kubectl get all -n ingress-nginx

```

![](.README_images/b93852cf.png)

## 2.4 通过 ingress 访问服务

```shell
# mac 启动
kubectl apply -f /yaml/service/app.yaml

# linux or windows 启动
kubectl apply -f /yaml/service/tomcat-service.yaml
```

查看服务

![](.README_images/5070810d.png)

查看 ingress

    kubectl get ingress

![](.README_images/d255c642.png)

# 2.5 minikube 访问

```shell
# 转发 service/ingress-nginx-controller -n ingress-nginx 端口
# 8000: 本机端口
# 80: 容器端口
kubectl port-forward service/ingress-nginx-controller 8000:80 -n ingress-nginx

# 配置 hosts 文件,生产上配置节点机器即可
127.0.0.1 tomcat.cnsre.cn
127.0.0.1 nginx1.com

# 命令访问
curl -H 'Host:tomcat.cnsre.cn' 127.0.0.1:8000
curl -H 'Host:nginx1.com' 127.0.0.1:8000
```

## 2.6 生产访问

配置 hosts,生产为任意节点的 IP 地址

![](.README_images/cb93b4e3.png)

```shell
echo "192.168.49.2 tomcat.cnsre.cn" >> /etc/hosts
echo "192.168.49.2 nginx1.com" >> /etc/hosts
```

请求服务，获取端口配置，32221 端口随机，后续优化

kubectl get svc -n ingress-nginx

![](.README_images/933e423f.png)

```shell
curl -H 'Host:tomcat.cnsre.cn' 127.0.0.1:32221
curl -H 'Host:nginx1.com' 127.0.0.1:32221
```

![](.README_images/84d9c364.png)

ps: 生产域名绑定，就不用做映射了

# 3. 查看服务

查看 service/ingress-nginx-controller 端口,配置域名，通过 kubectl get all -n ingress-nginx 端口访问

![](.README_images/2.png)

![](.README_images/af7885f8.png)

![](.README_images/a00eff03.png)

![](.README_images/1..png)
