# 关于 ingress 

配置 ingress 由于没有绑定域名，需要在本地配置域名，域名指向任一节点 node ip

- https: ingress/ingress-nginx 配置 https ingress-nginx , http 和 https 都能访问
- http: service/ingress-nginx 普通，通过 nodeIp:nodePort(ingress-nginx-controller)  访问，https 不能访问

# harbor 

test 158262751sB.