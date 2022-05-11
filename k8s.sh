# 1. k8s 命令替换
kubectl exec pod_name -- env

kubectl exec -it my-tomcat-685b8fd9c9-rw42d -- sh

kubectl scale --replicas=5 deployment my-tomcat

kubectl set image deployment my-tomcat tomcat=tomcat:8.0.41-jre8-alpine

kubectl describe pod my-tomcat-547db86547-4btmd

kubectl rollout history deploy my-tomcat

# 参数可以指定回退的版本
kubectl rollout undo deployment my-tomcat --to-revision  1

# 2. 查看详细信息
kubectl get pod -o wide


wget https://cdn.jsdelivr.net/gh/lework/kainstall@master/kainstall-centos.sh

https://github.com/lework/kainstall

bash kainstall-centos.sh init \
  --master 43.129.195.92 \
  --worker 101.32.33.82,101.32.202.86\
  --user root \
  --password 158262751sb. \
  --port 22 \
  --version 1.20.6

kainstall-centos.sh reset \
--user root \
--password 158262751sb.
