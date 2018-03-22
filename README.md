# 查单词


## 介绍

自己单词量很少，经常查单词，但查单词软件启动速度太慢，等待广告时间长，所以写了这个工具。
本地拥有1万4千个单词，满足一般日常查询。

## 处理的问题

### 1.单词资源的分割和数据库分类存储

- 使用正则表达式分割
- 数据库通过使用字母的unicode值来代替

### 2.插入数据库太慢

- 显示开启事务，让将要执行的任务一次提交到表中
- 使用`sqlite3_prepare_v2`提前编译好SQL语句
