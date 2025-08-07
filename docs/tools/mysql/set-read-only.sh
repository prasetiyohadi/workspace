#!/bin/sh
/usr/bin/mysql -uroot -p -e 'set global super_read_only = 1;'
