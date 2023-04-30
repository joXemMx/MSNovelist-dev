#!/bin/bash


DB_STEP1=$(sed -n 's/^ *db_step1: *//p' /beegfs/vo87poq/msnovelist/target/log.yaml)

sqlite3 /beegfs/vo87poq/msnovelist/$DB_STEP1 << EOF
    create index if not exists folds ON compounds (grp);
EOF
