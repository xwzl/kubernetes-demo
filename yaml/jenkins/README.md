# 1. 安装 jenkins

[官网](https://www.jenkins.io/download/)下载可执行 war 包,可选择 yum、docker、K8S 部署

```shell
# 后台启动
nohup java -jar jenkins.war --httpPort=10000 >> ./app.log 2>&1 &
# 输入 localhost:10000 登录页面,查看 app.log秘钥 (倒数几行)
cat app.log 
```

![](.images/90c07755.png)

ps: 本地有 docker、jdk、mvn、kubetcl 环境

# 2. 创建一个 Job 流水线

新建 item

![](.images/9ca1740f.png)

选择流水线

![](.images/57a22cc8.png)

复制下面的编排脚本到流水线中

![](.images/b9e9dd88.png)



需要注意的点,以下的参数要随之修改：
- WORK_SPACE: demo 改为相应的 item name
- JAR_NAME: 不用换修改
- MODULE: 打包的模块路径必须修改
- EXPOSE_PORT: 暴露端口与服务端口一直即可
- HOST: 目前服务通过暴露域名的方式启动
  - PATH: 待实现
  - ENABLE_INGRESS: 配套使用
- settings.xml: 找我要

本机包含证书的，先创建证书
```shell
#创建自签证书文件
openssl req -x509 -nodes -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginx/O=nginx"

#创建后会生成两个文件
tls.crt tls.key

#创建 secret
kubectl create secret tls tls-secret --key tls.key --cert tls.crt

#查看
kubectl get secret
```
然后把当前目录下文件和脚本拷贝到 /opt/jenkins 中

```
node {
    
    def mvnHome
    
    // jenkins 目录地址，必须机器的地址配置
    env.WORK_SPACE='/root/.jenkins/workspace/demo'
    // 打包后的 jar 名称，不相同需要设置，并修改 Dockerfile 的 copy 名称 
    env.JAR_NAME="app-1.0.0.jar"
    // ingress 监听的域名
    env.HOST="tomcat.cnsre.cn"
    // 容器暴露端口
    env.EXPOSE_PORT="8080";
    // docker build 基础路径
    env.BUILD_DIR='/opt/build-workspace'
    // 项目中模块的地址
    env.MODULE="java/interview"
    // xml 配置
    env.MAVEN_CONFIG_PATH="/opt/config/settings.xml"
    // docker 镜像仓库地址
    env.DOCKER_REGISTER_URL="registry.cn-hangzhou.aliyuncs.com/xuweizhi"
    // 是否开启 ingress
    env.ENABLE_INGRESS="true"
    // 下载项目
    stage('download project') {
        // 项目配置地址
        git 'https://gitee.com/xuweizhi/summary.git'
    }
    
    // mvn 打包
    stage('mvn install') {
        // 配置 zsh 必须执行该命令
        sh 'source ~/.bash_profile'
        // dubbo 模块需要打包父模块,需要手动更改
        sh 'mvn clean install -pl ${MODULE} -amd -s ${MAVEN_CONFIG_PATH} -Dmaven.test.skip=true -P rdc'
    }
    
    // 制作镜像并上传
    stage('docker build') {
        // 此处要登录一下 docker login 仓库否则 push 失败
        sh 'bash /opt/config/docker.sh'
    }
    
    // 不需要 ingress 要注释一下模板，位于 /op/build-workspace/kubernetes-demo/yaml/spring-boot.yaml
    stage('kubernetes deploy') {
        sh 'bash /opt/config/deploy.sh'
    }

}
```
