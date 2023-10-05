import os
import h5py
import pandas as pd

path = os.path.expanduser('~/MSNovelist-dev')
eval_db = h5py.File(f'{path}/independent_msnovelist.hdf5', mode='r')
df = pd.DataFrame(eval_db['csiPredicted'])
print(f'Amount of duplicates in FP: {df.duplicated().sum()}')
duplicates = df.duplicated()
indices_of_duplicates = df[duplicates].index
indices_of_duplicates = indices_of_duplicates[0]
duplicate_inchi = eval_db['inchikeys'][indices_of_duplicates]
if list(eval_db['inchikeys']).count(duplicate_inchi) < 2:
    print('Duplicate FP has single inchikey')
else:
    print('Duplicate FP has multiple inchikeys')

k = []
i = 0
for index, row in df.iterrows():
    if list(row) == list(df[duplicates].loc[indices_of_duplicates]):
        k.append(i)
    i += 1
print(f'Indices with same FP: {k}')
print(f'Inchikey of first index: {eval_db["inchikeys"][k[0]]}, SMILES of first index: {eval_db["smiles"][k[0]]}')
print(f'Inchikey of first index: {eval_db["inchikeys"][k[1]]}, SMILES of first index: {eval_db["smiles"][k[1]]}')

from rdkit import Chem
from rdkit.Chem import rdMolDescriptors
def get_formulas_from_smiles(smiles):
    formulas = []
    for smiles_real in smiles:
        try:
            mol = Chem.MolFromSmiles(smiles_real)
            mf = rdMolDescriptors.CalcMolFormula(mol)
            mf = mf.replace('+', '').replace('-', '')
            formulas.append(mf)
        except:
            print("Exception found!")
            formulas.append('invalid')
    return formulas

formulas = get_formulas_from_smiles([eval_db["smiles"][k[0]], eval_db["smiles"][k[1]]])
print(f'Molecular formulas of both structures: {formulas}')
