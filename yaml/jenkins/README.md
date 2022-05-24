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

```shell
node {
    def mvnHome
    env.BASE_DIR='/Users/xuweizhi/.jenkins/workspace/demo/'
    env.DOCKER_DIR='/root/build-workspace/'
    stage('download project') {
 
        git 'https://gitee.com/xuweizhi/summary.git'
        sh 'ls -al'
    }
    
    stage('mvn install') {
        sh 'source ~/.bash_profile'
        sh 'mvn clean install -pl java/interview -amd -s /Users/xuweizhi/.m2/settings2.xml -Dmaven.test.skip=true -P rdc'
    }


}
```
