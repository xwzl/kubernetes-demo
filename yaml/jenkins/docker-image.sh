#!/bin/bash

if [ "${BUILD_DIR}" == "" ]; then
  exit 1
fi
# ${JOB_NAME} 变量 jenkins 自带
DOCKER_DIR=${BUILD_DIR}/${JOB_NAME}
