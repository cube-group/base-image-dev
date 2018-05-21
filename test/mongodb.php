<?php

// 链接服务器
$m = new MongoClient();
// 选择一个数据库
$db = $m->school;
// 选择一个集合（ Mongo 的“集合”相当于关系型数据库的“表”）
$collection = $db->student;

$fruitQuery = array('stu_id' => array('$gte'=>15,'$lte'=>22)); //设置查询条件
$field=array('_id'=>0);//设置显示字段

$res=$collection->find($fruitQuery,$field);

foreach ($res as $stu) {
var_dump($stu);
}
