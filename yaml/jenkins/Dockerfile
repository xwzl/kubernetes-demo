FROM arm64v8/openjdk:8-jdk-oraclelinux7

ENV DEFAULT_WORK_DIR=/opt/java

ARG EXPOSE_PORT

# 指定工作目录，后面的命令在改目录下
WORKDIR $DEFAULT_WORK_DIR

COPY *.jar app.jar

EXPOSE $EXPOSE_PORT

ENTRYPOINT ["java","-jar","app.jar"]


