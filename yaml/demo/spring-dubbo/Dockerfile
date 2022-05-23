FROM openjdk:8-jre-alpine

ENV DEFAULT_WORK_DIR=/etc/docker

# 构建时参数 --build-arg JAVA_PATH 指定
ARG JAVA_PATH

# 指定工作目录，后面的命令在改目录下
WORKDIR $DEFAULT_WORK_DIR

COPY $JAVA_PATH app.jar

ENTRYPOINT ["java","-jar","app.jar"]


