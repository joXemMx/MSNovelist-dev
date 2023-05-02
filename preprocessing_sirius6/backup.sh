#!/bin/bash

DB_STEP1=$(sed -n 's/^ *db_step1: *//p' /beegfs/vo87poq/msnovelist/target/log.yaml)
DB_STEP2=$(sed -n 's/^ *db_step2: *//p' /beegfs/vo87poq/msnovelist/target/log.yaml)
BACKUP_TARGET=/sirius6_db/$(date +%s)

mkdir -p /beegfs/vo87poq/msnovelist$BACKUP_TARGET
echo copying $DB_STEP1 to $BACKUP_TARGET
cp /beegfs/vo87poq/msnovelist/$DB_STEP1 /beegfs/vo87poq/msnovelist$BACKUP_TARGET
echo copying $DB_STEP2 to $BACKUP_TARGET
cp /beegfs/vo87poq/msnovelist/$DB_STEP2 /beegfs/vo87poq/msnovelist$BACKUP_TARGET

