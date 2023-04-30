#!/bin/bash

DB_STEP1=$(sed -n 's/^ *db_step1: *//p' ~/msnovelist/target/log.yaml)
DB_STEP2=$(sed -n 's/^ *db_step2: *//p' ~/msnovelist/target/log.yaml)

sqlite3 ~/msnovelist/$DB_STEP1 << EOF
    UPDATE compounds
    SET perm_order = random();
EOF

sqlite3 ~/msnovelist/$DB_STEP2 << EOF
    UPDATE compounds
    SET perm_order = random();
EOF
