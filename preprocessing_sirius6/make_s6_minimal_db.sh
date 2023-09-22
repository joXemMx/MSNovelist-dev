#!/bin/bash

DB_STEP1=$(sed -n 's/^ *db_step2: *//p' ~/msnovelist/target/log-subset.yaml)
DBNEW_UUID=$(python -c "import uuid; print(uuid.uuid4())")
COMPOUNDS_LIMIT=1

echo "creating target/sirius6-minimal.db"

sqlite3 ~/msnovelist/$DB_STEP1 << EOF
    ATTACH DATABASE '/home/vo87poq/msnovelist/target/sirius6-minimal.db' AS target;
    CREATE TABLE target.compounds AS 
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold0'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold1'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold2'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold3'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold4'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold5'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold6'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold7'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold8'
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold9'
        LIMIT $COMPOUNDS_LIMIT
    )
    ORDER BY grp;
EOF

echo "created target/sirius6-minimal.db"