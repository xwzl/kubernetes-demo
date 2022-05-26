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
进入容器内部
    kubectl exec -it pod/spring-boot-74f6975bd6-5rnv7 -- sh
