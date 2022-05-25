# 任意 Java 项目


# 删除
docker rm $(docker ps -aq | grep -v -E "bffa249942c1|36c1ae091842")

docker rmi $(docker images -aq | grep -v -E "6a29e77b4fe6|fcd5f7d32d48|f16c30136ff3|ac0e4fe3e6b0")

kubectl get pods -l app=spring-boot

kubectl get pods -l 'group in (dev,test)' -n default
kubectl get pods -l 'group notin (dev,test)' -n default

## 健康通过 livenessProbe 

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