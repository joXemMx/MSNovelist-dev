#!/bin/bash

DB_STEP1=$(sed -n 's/^ *db_step1: *//p' ~/msnovelist/target/log.yaml)
DB_STEP2=$(sed -n 's/^ *db_step2: *//p' ~/msnovelist/target/log.yaml)
BACKUP_TARGET=/sirius6_db/$(date +%s)

mkdir -p ~/msnovelist$BACKUP_TARGET
echo copying $DB_STEP1 to $BACKUP_TARGET
cp ~/msnovelist/$DB_STEP1 ~/msnovelist$BACKUP_TARGET
echo copying $DB_STEP2 to $BACKUP_TARGET
cp ~/msnovelist/$DB_STEP2 ~/msnovelist$BACKUP_TARGET

