#!/bin/bash

DB_STEP2=~/msnovelist/target/sirius6-crossval-folds.db
DBNEW_UUID=$(python -c "import uuid; print(uuid.uuid4())")
# full amount is 30.000
COMPOUNDS_LIMIT=3000

echo "creating target/sirius6-$DBNEW_UUID.db"

sqlite3 $DB_STEP2 << EOF
    ATTACH DATABASE '/home/vo87poq/msnovelist/target/sirius6-$DBNEW_UUID.db' AS target;
    CREATE TABLE target.compounds AS 
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold0'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold1'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold2'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold3'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold4'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold5'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold6'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold7'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold8'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    UNION ALL
    SELECT * FROM (
        SELECT * FROM compounds
        WHERE grp = 'fold9'
        ORDER BY perm_order
        LIMIT $COMPOUNDS_LIMIT
    )
    ORDER BY perm_order;
    CREATE INDEX IF NOT EXISTS idx_folds ON compounds (grp);
    CREATE INDEX IF NOT EXISTS idx_inchikeys ON compounds (inchikey1);
EOF

echo "created  ~/msnovelist/target/sirius6-$DBNEW_UUID.db"
echo "db_step2: target/sirius6-$DBNEW_UUID.db" >> ~/msnovelist/target/log-subset.yaml

BACKUP_TARGET=~/msnovelist/sirius6_db/$(date +%s)
mkdir -p $BACKUP_TARGET
cp ~/msnovelist/target/sirius6-$DBNEW_UUID.db $BACKUP_TARGET