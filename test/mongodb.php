<?php

$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");
// 插入数据
$bulk = new MongoDB\Driver\BulkWrite;
$bulk->insert(['x' => 1, 'name' => 'taobao', 'url' => 'http://www.taobao.com']);
$bulk->insert(['x' => 2, 'name' => 'google', 'url' => 'http://www.google.com']);
$bulk->insert(['x' => 3, 'name' => 'baidu', 'url' => 'http://www.baidu.com']);
$manager->executeBulkWrite('test.sites', $bulk);

$filter = ['x' => ['$gt' => 1]];
$options = [
    'projection' => ['_id' => 0],
    'sort' => ['x' => -1],
];

// 查询数据
$query = new MongoDB\Driver\Query($filter, $options);
$cursor = $manager->executeQuery('test.sites', $query);
foreach ($cursor as $document) {
    var_dump($document);
}