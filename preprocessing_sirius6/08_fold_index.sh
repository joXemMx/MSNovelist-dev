#!/bin/bash


DB_STEP1=$(sed -n 's/^ *db_step1: *//p' ~/msnovelist/target/log.yaml)

sqlite3 ~/msnovelist/$DB_STEP1 << EOF
    create index if not exists folds ON compounds (grp);
EOF
