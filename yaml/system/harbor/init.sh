#!/bin/bash

domain_url="$1"

openssl genrsa -out ca.key 4096

# 生成 CA 证书
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=${domain_url}" \
 -key ca.key \
 -out ca.crt

# 生成 CA 证书私钥
openssl genrsa -out ${domain_url}.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=${domain_url}" \
    -key ${domain_url}.key \
    -out ${domain_url}.csr
# ip 地址修改
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = IP:${domain_url}
EOF

# domain
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in  ${domain_url}.csr \
    -out ${domain_url}.crt


# 将服务器证书和密钥复制到 Harbor 主机上的 certficates 文件夹中。
mkdir -p /data/cert
cp ${domain_url}.crt  /data/cert/
cp ${domain_url}.key /data/cert/

# Docker 守护进程将.crt文件解释为 CA 证书，将.cert文件解释为客户端证书。
openssl x509 -inform PEM -in ${domain_url}.crt -out ${domain_url}.cert

mkdir -p /etc/docker/certs.d/${domain_url}/
cp ${domain_url}.cert /etc/docker/certs.d/${domain_url}/
cp ${domain_url}.key /etc/docker/certs.d/${domain_url}/
cp ca.crt /etc/docker/certs.d/${domain_url}/

systemctl restart docker