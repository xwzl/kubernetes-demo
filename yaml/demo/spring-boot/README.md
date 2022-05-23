# 任意 Java 项目


# 删除
docker rm $(docker ps -aq | grep -v -E "bffa249942c1|36c1ae091842")

docker rmi $(docker images -aq | grep -v -E "6a29e77b4fe6|fcd5f7d32d48|f16c30136ff3|ac0e4fe3e6b0")

