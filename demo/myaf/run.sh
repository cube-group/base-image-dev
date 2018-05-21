#!/usr/bin/env bash

docker rm -f dev
docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
-p 6379:6379 \
-p 11211:11211 \
-p 27107:11211 \
-v /Users/chenqionghe/web/MyStudy/cube/base-image-dev/demo/myaf:/var/www/html \
--rm registry.eoffcn.com/dev:latest
docker logs dev
docker exec -it dev bash


mongod --dbpath=/usr/local/mongodb/data --logpath=/usr/local/mongodb/log --logappend --port=6699 --fork