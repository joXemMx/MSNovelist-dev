#!/bin/bash


DB_STEP1=$(sed -n 's/^ *db_step1: *//p' ~/msnovelist/target/log.yaml)

sqlite3 ~/msnovelist/$DB_STEP1 << EOF
    -- select inchikey, grp, id, 'fold' || (id % 10) FROM compounds LIMIT 300;
    update compounds set grp = 'fold' || (id % 10) WHERE grp <> 'invalid';
    --select * from compounds WHERE grp = 'invalid' LIMIT 10;
EOF
