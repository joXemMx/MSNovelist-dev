import os
os.environ['COMPUTERNAME']='DOCKER-LIGHT'

from predictor import Predictor
from tqdm import tqdm
import numpy as np
import pandas as pd
import h5py
from rdkit import Chem
from rdkit.Chem import rdMolDescriptors

eval_db = h5py.File('/home/vo87poq/MSNovelist-dev/independent_msnovelist.hdf5', mode='r')
smiles_db = eval_db['smiles']
csi_pred_db = eval_db['csiPredicted']

formulas = []
for smiles in smiles_db:
    try:
        mol = Chem.MolFromSmiles(smiles)
        mf = rdMolDescriptors.CalcMolFormula(mol)
        mf = mf.replace('+', '').replace('-', '')
        formulas.append(mf)
    except:
        print("Exception found!")
        formulas.append('invalid')

k = 0
predictions = pd.DataFrame()
total_iterations = len(formulas)
with tqdm(total=total_iterations) as pbar:
    for i, (mf, fp, smiles) in enumerate(zip(formulas, csi_pred_db, smiles_db)):
        # Your processing code here
        if k==20:
            predictions.to_csv('eval_test.csv')
            break
        k = k+1
        pred = Predictor.predict(mf, fp)
        pred.insert(loc=0, column='smilesReal', value=[smiles]*128)
        pred.insert(0, 'id', pred.pop('id'))
        predictions = predictions.append(pred, ignore_index=True)
        # Update the progress bar
        pbar.update(1)

