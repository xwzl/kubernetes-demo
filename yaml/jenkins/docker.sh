#!/bin/bash

if [ "${BUILD_DIR}" == "" ]; then
  echo "env 'BUILD_DIR' is not set"
  exit 1
fi

# ${JOB_NAME} 变量 jenkins 自带
DOCKER_DIR=${BUILD_DIR}/${JOB_NAME}

if [ ! -d ${DOCKER_DIR} ]; then
  mkdir -p ${DOCKER_DIR}
fi

echo "docker workspace: ${DOCKER_DIR}"

JENKINS_DIR=${WORK_SPACE}/${MODULE}

echo "jenkins workspace: ${JENKINS_DIR}"

if [ ! -d "${JENKINS_DIR}/target" ]; then
  echo "target jar file not found ${JENKINS_DIR}/target/${JAR_NAME}"
  exit 1
fi

VERSION=$(date +%Y%m%d%H%M%S)

function copy::dockerfile() {

  if [ ! -d "${BUILD_DIR}/kubernetes-demo" ]; then
    cd ${BUILD_DIR}
    git clone https://gitee.com/xuweizhi/kubernetes-demo.git
  else
    cd ${BUILD_DIR}/kubernetes-demo
    git pull
  fi

  cp "${BUILD_DIR}"/kubernetes-demo/yaml/jenkins/Dockerfile "${DOCKER_DIR}"
}

function build::image() {
  copy::dockerfile

  cd "${DOCKER_DIR}" || rm -rf *

  cp "${JENKINS_DIR}"/target/*.jar "${DOCKER_DIR}"
  IMAGE_NAME=${DOCKER_REGISTER_URL}/"${JOB_NAME}":"${VERSION}"

  echo "building image:${IMAGE_NAME}"
  docker build --build-arg EXPOSE_PORT=${EXPOSE_PORT} -t ${IMAGE_NAME} .
  echo "${IMAGE_NAME}" > ${WORK_SPACE}/IMAGE
  docker push ${IMAGE_NAME}
}

build::image
