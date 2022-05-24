#!/bin/bash

name=${JOB_NAME}
image=$(cat ${WORK_SPACE}/IMAGE)
host=${HOST}
expose_port=${EXPOSE_PORT}

echo "deploying ... name:${name},iamge:${image},host:${HOST},expose_port:${expose_port}"

rm -f spring-boot.yaml

if [ "${ENABLE_INGRESS}" == "true" ]; then
  cp "${BUILD_DIR}"/kubernetes-demo/yaml/jenkins/spring-boot-ingress.yaml ./spring-boot.yaml
else
  cp "${BUILD_DIR}"/kubernetes-demo/yaml/jenkins/spring-boot.yaml ./spring-boot.yaml
fi

sed -i "s,{{.name}},${name},g" spring-boot.yaml
sed -i "s,{{.image}},${image},g" spring-boot.yaml
sed -i "s,{{.host}},${host},g" spring-boot.yaml
sed -i "s,{{.expose_port}},${expose_port},g" spring-boot.yaml

echo "ready to apply"

# 默认第一次部署
generation=0
# 如果部署村子啊，保存上一次部署的版本号
# shellcheck disable=SC2126
# shellcheck disable=SC2046
if [ $(kubectl get deploy | grep "${JOB_NAME}" | wc -l) -gt 0 ]; then
  generation=$(kubectl get deploy ${JOB_NAME} -o go-template='{{.metadata.generation}}')
fi
kubectl apply -f spring-boot.yaml

echo "apply ok"

cat spring-boot.yaml

# 健康检查: kubectl get deploy demo -o go-template='{{.}}' 查看 deployment 状态
function check::deploy() {
  # 健康检查时可能当前部署没有成功，因此比较前后两次部署版本好
  # shellcheck disable=SC2160
  count1=10
  while [ $count1 -gt 0 ]; do
    current_generation=$(kubectl get deploy ${JOB_NAME} -o go-template='{{.metadata.generation}}')
    echo "deploy is deploying,current_version:$current_generation,old_version:$generation"
    if [ ${current_generation} -gt ${generation} ]; then
      echo "deploy is ready"
      break
    fi
    ((count1--))
    sleep 2
  done
}

function check::health() {
  count=60
  success=0
  # 分隔符
  IFS=","

  while [ $count -gt 0 ]; do

    replicas=$(kubectl get deploy demo -o go-template='{{.status.replicas}},{{.status.updatedReplicas}},{{.status.readyReplicas}},{{.status.availableReplicas}}')

    echo "replicas:${replicas}"
    # shellcheck disable=SC2206
    arr=(${replicas})

    if [ "${arr[0]}" == "${arr[1]}" -a "${arr[1]}" == "${arr[2]}" -a "${arr[2]}" == "${arr[3]}" ]; then
      echo "health check success !"
      # shellcheck disable=SC2034
      success=1
      break
    fi
    ((count--))
    sleep 2
  done

  if [ ${success} -ne 1 ]; then
    echo "health check failed!"
  fi
}

check::deploy

check::health
