import numpy as np
import sqlite3
import pandas as pd

training_set = '/home/vo87poq/msnovelist/target/sirius6-f7b01257-359b-4f66-bd54-af583d536c60.db'
conn = sqlite3.connect(training_set)
query = 'SELECT inchikey1, grp FROM compounds'
training_data = pd.read_sql(query, conn)
conn.close()

validation_set = '/home/vo87poq/MSNovelist-dev/gnps_evaluation_data/gnps-evaluation-instances.csv'
validation_data = pd.read_csv(validation_set, sep='\t')
print(f'Size of GNPS set: {len(validation_data)}')

# Merge the datasets on 'inchikey14' and 'inchikey1', and extract the 'grp' column
merged_data = validation_data.merge(training_data, left_on='InChIKey14', right_on='inchikey1', how='left')

# Add the 'grp' column to the validation dataset
validation_data['grp'] = merged_data['grp'].fillna(f'excluded')

print(f'Amount of molecules from GNPS in any training fold: {len(validation_data) - list(validation_data["grp"]).count(np.nan)}')
print('Amount of molecules from GNPS in specific training fold:')
print(f'\tFold 0: {list(validation_data["grp"]).count("fold0")}')
print(f'\tFold 1: {list(validation_data["grp"]).count("fold1")}')
print(f'\tFold 2: {list(validation_data["grp"]).count("fold2")}')
print(f'\tFold 3: {list(validation_data["grp"]).count("fold3")}')
print(f'\tFold 4: {list(validation_data["grp"]).count("fold4")}')
print(f'\tFold 5: {list(validation_data["grp"]).count("fold5")}')
print(f'\tFold 6: {list(validation_data["grp"]).count("fold6")}')
print(f'\tFold 7: {list(validation_data["grp"]).count("fold7")}')
print(f'\tFold 8: {list(validation_data["grp"]).count("fold8")}')
print(f'\tFold 9: {list(validation_data["grp"]).count("fold9")}')

validation_data.to_csv('folds-gnps-evaluation-instances.csv', index=False, sep='\t')