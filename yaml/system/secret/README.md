## 3.1 生成证书

ingress-nginx 配置 HTTPS 访问

```shell
#创建自签证书文件
openssl req -x509 -nodes -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginx/O=nginx"

#创建后会生成两个文件
tls.crt tls.key

#创建 secret, tls-secret 可自定义
kubectl create secret tls1 tls-secret --key tls.key --cert tls.crt

#查看
kubectl get secret
```

修改 tomcat-ingress yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-demo
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  # 新增
  tls:
    - hosts:
        - tomcat.cnsre.cn
      secretName: tls-secret
    - hosts:
        - nginx1.com
        secretName: tls-secret
  rules:
    - host: tomcat.cnsre.cn
      http:
        paths:
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: tomcat-service-yaml
                port:
                  number: 8080
    - host: nginx1.com
      http:
        paths:
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: tomcat-service-yaml
                port:
                  number: 8080
```
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -f dashboard.yaml --version 5.4.1 --namespace kube-system