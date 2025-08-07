#!/bin/sh
echo "Input required parameters: "
read -p "Master Host: "  MASTER_HOST
if [ -z "$MASTER_HOST" ]; then echo "Master Host is required!"; exit 0; fi

read -p "Master User: "  MASTER_USER
if [ -z "$MASTER_USER" ]; then echo "Master User is required!"; exit 0; fi

read -p "Master Password: "  MASTER_PASSWORD
if [ -z "$MASTER_PASSWORD" ]; then echo "Master Password is required!"; exit 0; fi

read -p "innobackup_binlog_info Directory: "  XTRABACKUP_INFO_DIR
XTRABACKUP_INFO_FILE=$XTRABACKUP_INFO_DIR/xtrabackup_binlog_info

if [ -f "$XTRABACKUP_INFO_FILE" ]; then
    GTID_PURGED=$(cut -f3- $XTRABACKUP_INFO_FILE)
    /usr/bin/mysql -uroot -p -e "set global gtid_purged='$GTID_PURGED'; change master to master_host='$MASTER_HOST', master_user='$MASTER_USER', master_password='$MASTER_PASSWORD', master_auto_position=1; start slave;"
else
    echo "xtrabackup_binlog_info doesn't exist!"
    exit 0
fi
