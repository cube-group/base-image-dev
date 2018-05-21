#!/usr/bin/env bash

docker rm -f dev
docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
-v /Users/chenqionghe/web/MyStudy/cube/base-image-dev/demo/myaf:/var/www/html \
-v /Users/chenqionghe/web/MyStudy/cube/base-image-dev/scripts/start.sh:/extra/start.sh \
--rm registry.eoffcn.com/dev:latest
docker logs dev
docker exec -it dev bash

