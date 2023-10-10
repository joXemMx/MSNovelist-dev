#!/bin/bash

DB_VAL=/home/vo87poq/msnovelist/target/sirius6-2ec0d5a2-4d84-47d9-ac54-22ae2961d139.db
VAL_SCRAMBLED=/home/vo87poq/msnovelist/target/scrambled_validation.db

sqlite3 $DB_VAL << EOF
    ATTACH DATABASE '$VAL_SCRAMBLED' AS target;
    CREATE TABLE target.compounds AS SELECT * FROM compounds;
EOF
echo "created $VAL_SCRAMBLED"


DB_TRAIN=/home/vo87poq/msnovelist/target/sirius6-f7b01257-359b-4f66-bd54-af583d536c60.db
TRAIN_SCRAMBLED=/home/vo87poq/msnovelist/target/scrambled_train.db

sqlite3 $DB_TRAIN << EOF
    ATTACH DATABASE '$TRAIN_SCRAMBLED' AS target;
    CREATE TABLE target.compounds AS SELECT * FROM compounds;
EOF
echo "created $TRAIN_SCRAMBLED"