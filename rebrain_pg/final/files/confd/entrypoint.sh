#!/bin/sh
set -e
/usr/local/bin/confd -interval 1 -backend etcd -node http://etcd1:2379 -node http://etcd2:2379 -node etcd3:2379
