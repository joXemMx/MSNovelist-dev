
#!/bin/bash

DB_STEP2=$(sed -n 's/^ *db_step2: *//p' ~/msnovelist/target/log.yaml)
DBNEW_UUID=$(python -c "import uuid; print(uuid.uuid4())")
COMPOUNDS_LIMIT=100000


sqlite3 ~/msnovelist/$DB_STEP2 << EOF
    CREATE TEMPORARY TABLE inchikeys AS
        SELECT DISTINCT inchikey1 FROM compounds;
    CREATE TABLE inchikey_folds AS
        SELECT inchikey1, rowid AS id, rowid % 10 AS fold, 'fold' || ( rowid % 10 ) as grp_new  FROM inchikeys;
    UPDATE compounds SET grp = (SELECT grp_new FROM inchikey_folds WHERE inchikey_folds.inchikey1 = compounds.inchikey1) WHERE grp <> 'invalid';
    -- CREATE TABLE target.compounds AS
    --    SELECT * FROM compounds LIMIT $COMPOUNDS_LIMIT;
EOF

echo "created ~/msnovelist/target/sirius6-$DBNEW_UUID.db"
#echo "db_step1_subset: /target/sirius6-$DBNEW_UUID.db" >> /target/log.yaml

BACKUP_TARGET=~/msnovelist/sirius6_db/$(date +%s)
mkdir -p $BACKUP_TARGET
cp ~/msnovelist/target/sirius6-$DBNEW_UUID.db $BACKUP_TARGET