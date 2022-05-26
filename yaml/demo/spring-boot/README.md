# 任意 Java 项目

# 删除

docker rm $(docker ps -aq | grep -v -E "bffa249942c1|36c1ae091842")

docker rmi $(docker images -aq | grep -v -E "6a29e77b4fe6|fcd5f7d32d48|f16c30136ff3|ac0e4fe3e6b0")

kubectl get pods -l app=spring-boot

kubectl get pods -l 'group in (dev,test)' -n default
kubectl get pods -l 'group notin (dev,test)' -n default

# 1. 健康检查

### exec 命令的返回值来判断是否执行成功

```shell
# 执行
ps -ef|grep java|grep -v grep
# 判断 $？ 命令是否执行成功: 0 执行成功 1 执行失败
```

通过 http 请求判断请求地址的返回状态码：200 默认成功

```shell
httpGet:
    path: /hello/printIpAddress
    port: 8080
    scheme: HTTP
```

```shell
tcpSocket:
    port: 8080
```

# 2. 标签

```shell
# 展示节点标签
kubectl get nodes --show-labels=true
# 加标签
kubectl label nodes k8s-worker-node1 node=node1
```

# 3. 节点

```shell
kubectl get nodes k8s-master-node1 -o yaml
```

# 4. 部署

## 4.1 重建

apply/spring-boot-recreate.yaml

关闭原来的项目在重新构建

## 4.2 滚动部署

apply/spring-boot-rolling.yaml

会发现部分容器销毁，不会重建，直到部署完成

```shell
while sleep 0.2;do curl "https://demo.spring-boot.com/hello/printIpAddress"; done
```
交替打印两个版本内容

## 4.3 蓝绿部署

apply/spring-boot-blue-green.yaml

每次发布时带上版本号，service 根据版本号选择不同版本的 pod 服务

## 4.4 金丝雀部署

apply/spring-boot-blue-green.yaml service version 标签去掉，多个版本的服务都可以访问

# 5. 进入容器内部
sh 可以进去

    kubectl exec -it pod/spring-boot-74f6975bd6-5rnv7 -- sh