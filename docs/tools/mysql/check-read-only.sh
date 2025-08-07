#!/bin/sh
/usr/bin/mysql -uroot -p -e 'select @@global.read_only, @@global.super_read_only;'
