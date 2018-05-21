#!/usr/bin/env bash

docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
-p 6379:6379 \
-p 11211:11211 \
-v /Users/chenqionghe/web/MyStudy/cube/base-image-dev/demo/test:/var/www/html \
--rm registry.eoffcn.com/dev:latest
