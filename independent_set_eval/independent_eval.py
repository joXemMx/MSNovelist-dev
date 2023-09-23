import os
os.environ['COMPUTERNAME']='DOCKER-LIGHT'

from predictor import Predictor
import utility
from tqdm import tqdm
import pandas as pd
import h5py
import smiles_config as sc

from rdkit import RDLogger
lg = RDLogger.logger()
lg.setLevel(RDLogger.CRITICAL)

split = os.environ.get('SPLIT')
epoch = sc.config['weights'].split('-')[1]

parent_dir = f'split_{split}_evaluation_results'
directory = f'{parent_dir}/split_0_epoch_{epoch}_eval'
if not os.path.exists(parent_dir):
    os.mkdir(parent_dir)
if not os.path.exists(directory):
    os.mkdir(directory)

eval_db = h5py.File('/home/vo87poq/MSNovelist-dev/independent_msnovelist.hdf5', mode='r')
smiles_db = eval_db['smiles']
illegal_smiles = ['C[As](=O)(C)O', 'C[As](=O)(C)O', 'B(C1=CC=CC=C1)(C2=CC=CC=C2)OCCN']
csi_pred_db = eval_db['csiPredicted']

formulas = utility.get_formulas_from_smiles(smiles_db)

# failed_predictions = []
predictions = pd.DataFrame()
found_matches_position = []
with tqdm(total=len(formulas)) as pbar:
    for i, (mf, fp, smiles_real) in enumerate(zip(formulas, csi_pred_db, smiles_db)):
        pred = Predictor.predict(mf, fp)
        if pred is None:
            # failed_predictions.append(smiles)
            print(f'Prediction number {i} is None')
            continue

        # remove unneeded columns
        pred.drop('n', axis=1, inplace=True)
        pred.drop('k', axis=1, inplace=True)
        # add helpful columns
        pred.insert(loc=0, column='smiles_real', value=[smiles_real]*128)
        pred.insert(loc=0, column='sample_id', value=[i]*128)
        pred.insert(loc=0, column='id_in_sample', value=pred.pop('id'))

        # rdkit normalize predicted smiles
        norm_smiles = []
        for smiles in pred['smiles']:
            norm_smiles.append(utility.normalize_smiles(smiles))
        pred.insert(loc=4, column='normalized_smiles', value=norm_smiles)
        
        # compare normalized predicted smiles to normalized real smiles
        matches, match_exists = utility.match_smiles(smiles_real, norm_smiles)
        pred.insert(loc=len(pred.columns), column='match', value=matches)
        # if match was found, get its position
        if match_exists:
            found_matches_position.append(matches.index(1) + 1)

        predictions = predictions.append(pred, ignore_index=True)
        pbar.update(1)

# plot recovery
utility.plot_recovery_curve(found_matches_position, len(formulas)-3, split, epoch, directory)

# print(f'Total recoveries: {len(found_matches_position)}')
# print(f'Positions of found recoveries: {found_matches_position}')
# print(f'Recovery: {(len(found_matches_position)/(len(formulas)-3))*100}%')
predictions.to_csv(f'{directory}/evaluation_table_s{split}_e{epoch}.tsv', sep='\t')

with open('eval_summary.txt', 'a') as summary_file:
    summary_file.write(f'Recovery percentage on split {split}, epoch {epoch}: {(len(found_matches_position)/(len(formulas)-3))*100}\n')
    
# with open("failed_predictions.txt", "w") as output:
#     output.write(str(failed_predictions))