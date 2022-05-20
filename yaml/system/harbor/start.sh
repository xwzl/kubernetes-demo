#!/bin/bash
docker stop Harbornginx

docker rm Harbornginx

docker run -idt --net=host --name Harbornginx -p 80:80 -v /root/nginx.conf:/etc/nginx/nginx.conf nginx