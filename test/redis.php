<?php
//实例化redis
$redis = new Redis();
//连接
$redis->connect('127.0.0.1', 6379);
//检测是否连接成功
echo "Server is running: " . $redis->ping();
// 输出结果 Server is running: +PONG
$redis->set('key', 'This is a test!');
//获取一个字符串的值
echo $redis->get('cat');
