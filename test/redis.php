<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
$redis->set('key', 'This is a test!');
echo $redis->get('key');

$redis->lPush("queue", 1, 2, 3, 4, 5);

echo PHP_EOL;
echo "range: " . implode('|',$redis->lRange('queue', 0, -1)) . PHP_EOL;
echo "pop: " . $redis->rPop('queue') . PHP_EOL;
echo "pop: " . $redis->rPop('queue') . PHP_EOL;
echo "pop: " . $redis->rPop('queue') . PHP_EOL;
echo "pop: " . $redis->rPop('queue') . PHP_EOL;
echo "pop: " . $redis->rPop('queue') . PHP_EOL;
