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
    MASTER_LOG_FILE=$(cat $XTRABACKUP_INFO_FILE | awk '{print $1}')
    MASTER_LOG_POS=$(cat $XTRABACKUP_INFO_FILE | awk '{print $2}')
    /usr/bin/mysql -uroot -p -e "change master to master_host='$MASTER_HOST', master_user='$MASTER_USER', master_password='$MASTER_PASSWORD', master_log_file='$MASTER_LOG_FILE', master_log_pos=$MASTER_LOG_POS; start slave;"
else
    echo "xtrabackup_binlog_info doesn't exist!"
    exit 0
fi
