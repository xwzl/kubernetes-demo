# 对命令空间进行限制

```shell
kubectl apply -f test-space.yaml
kubectl create -f limit-resourse.yaml -n test
kubectl describe limits -n test
```
