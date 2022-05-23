FROM openjdk:8-jre-alpine

ENV DEFAULT_WORK_DIR=/etc/docker

# 指定工作目录，后面的命令在改目录下
WORKDIR $DEFAULT_WORK_DIR

COPY app-*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]


