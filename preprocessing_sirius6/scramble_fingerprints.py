import sqlite3
import numpy as np

## scramble validation database fingerprint_degraded from 10fold models
conn = sqlite3.connect('/home/vo87poq/msnovelist/target/scrambled_validation.db')
cursor = conn.cursor()

# Update all rows in the "fingerprint_degraded" column with a single random float32 array of length 5000 with values ranging from 0 to 1
cursor.execute("UPDATE compounds SET fingerprint_degraded = ?", (np.random.rand(5000).astype(np.float32).tobytes(),))
conn.commit()
conn.close()


## scramble train database fingerprint_degraded from 10fold models
conn = sqlite3.connect('/home/vo87poq/msnovelist/target/scrambled_train.db')
cursor = conn.cursor()

# Update all rows in the "fingerprint_degraded" column with a single random float32 array of length 5000 with values ranging from 0 to 1
cursor.execute("UPDATE compounds SET fingerprint = ?", (np.random.randint(2, size=5000).astype(np.uint8).tobytes(),))
conn.commit()
conn.close()