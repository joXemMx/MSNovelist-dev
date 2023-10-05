import os
os.environ['COMPUTERNAME']='DOCKER-LIGHT'

from independent_set_eval.predictor import Predictor
import independent_set_eval.utility as utility
from tqdm import tqdm
import pandas as pd
import smiles_config as sc

from rdkit import RDLogger
lg = RDLogger.logger()
lg.setLevel(RDLogger.CRITICAL)

# os.environ['SPLIT'] = 'test'
split = 0
epoch = 22

path = os.path.expanduser('~/MSNovelist-dev')
eval_dir = f'{path}/gnps_set_eval/evaluation_results'
parent_dir = f'{eval_dir}/split_{split}_evaluation_results'
directory = f'{parent_dir}/split_{split}_epoch_{epoch}_eval'
if not os.path.exists(directory):
    os.makedirs(directory)

# import data
eval_db = pd.read_csv(f'{path}/gnps_set_eval/folds-gnps-evaluation-instances.csv', sep='\t', usecols=['csiPredicted', 'smiles', 'grp'])
print(f'There are {len(eval_db)} elements in the GNPS set')
eval_db.drop_duplicates()
print(f'There are {len(eval_db)} unique elements in the GNPS set')

smiles_db = eval_db['smiles']
# illegal_smiles = ['C[As](=O)(C)O', 'C[As](=O)(C)O', 'B(C1=CC=CC=C1)(C2=CC=CC=C2)OCCN']
csi_pred_db = eval_db['csiPredicted']
formulas = utility.get_formulas_from_smiles(smiles_db)

# failed_predictions = []
formula_match = 0
predictions = pd.DataFrame()
found_matches_position = []
with tqdm(total=len(formulas)) as pbar:
    for i, (mf, fp, smiles_real) in enumerate(zip(formulas, csi_pred_db, smiles_db)):

        pred = Predictor.predict(mf, fp)
        if pred is None:
            # failed_predictions.append(smiles)
            pbar.update(1)
            continue

        # rename smiles column
        pred.rename(columns={"smiles": "predicted_smiles"}, inplace=True)
        # remove unneeded columns
        pred.drop('n', axis=1, inplace=True)
        pred.drop('k', axis=1, inplace=True)
        # add helpful columns
        pred.insert(loc=0, column='real_smiles', value=[smiles_real]*128)
        pred.insert(loc=0, column='sample_id', value=[i]*128)
        pred.insert(loc=0, column='id_in_sample', value=pred.pop('id'))

        # rdkit normalize predicted smiles
        norm_smiles = []
        for smiles in pred['predicted_smiles']:
            norm_smiles.append(utility.normalize_smiles(smiles))
        pred.insert(loc=4, column='normalized_predicted_smiles', value=norm_smiles)
        
        # compare normalized predicted smiles to normalized real smiles
        norm_smiles_real = utility.normalize_smiles(smiles_real)
        pred.insert(loc=4, column='normalized_real_smiles', value=[norm_smiles_real]*128)

        matches, match_exists = utility.match_smiles(norm_smiles_real, norm_smiles)
        pred.insert(loc=len(pred.columns), column='match', value=matches)

        # add molecular formulas to result table
        pred.insert(loc=4, column='real_formula', value=[mf]*128)
        pred_formulas = utility.get_formulas_from_smiles(pred['predicted_smiles'])
        pred.insert(loc=5, column='predicted_formula', value=pred_formulas)
        for pf in pred_formulas:
            if pf == mf:
                formula_match += 1

        # if match was found, get its position
        if match_exists:
            found_matches_position.append(matches.index(1) + 1)

        # append to predictions table
        predictions = predictions.append(pred, ignore_index=True)
        pbar.update(1)

# plot recovery
utility.plot_recovery_curve(found_matches_position, len(formulas)-3, split, epoch, directory)

# print(f'Total recoveries: {len(found_matches_position)}')
# print(f'Positions of found recoveries: {found_matches_position}')
# print(f'Recovery: {(len(found_matches_position)/(len(formulas)-3))*100}%')

# add to summary of whole evaluation
if not os.path.isfile(f'{eval_dir}/eval_summary.tsv'):
    df = pd.DataFrame(columns=['split', 'epoch', 'found_matches', 'recovery_percentage', 'invalid_predictions', 'invalid_predictions_percentage'])
    df.to_csv('eval_summary.tsv', sep='\t', index=False)
invalid_count = predictions['normalized_predicted_smiles'].value_counts()['invalid']
data = {'split': split,
        'epoch': epoch,
        'found_matches': len(found_matches_position),
        'recovery_percentage': float("{:.2f}".format((len(found_matches_position)/(len(formulas)-3))*100)),
        'invalid_predictions': invalid_count,
        'invalid_predictions_percentage': float("{:.2f}".format((invalid_count/len(predictions))*100)),
        'matching_formulas': formula_match,
        'matching_formulas_percentage': float("{:.2f}".format((formula_match/(len(predictions)-invalid_count))*100)),
        'matches_pos_1': int(found_matches_position.count(1)),
        'matches_pos_2': int(found_matches_position.count(2)),
        'matches_pos_3': int(found_matches_position.count(3)),
        'matches_pos_4': int(found_matches_position.count(4)),
        'matches_pos_5': int(found_matches_position.count(5)),
        'matches_pos_6': int(found_matches_position.count(6)),
        'matches_pos_7': int(found_matches_position.count(7)),
        'matches_pos_8': int(found_matches_position.count(8)),
        'matches_pos_9': int(found_matches_position.count(9)),
        'matches_pos_10': int(found_matches_position.count(10))
        }
tmp_df = pd.DataFrame(data, index=[0])
summary_df = pd.read_csv(f'{eval_dir}/eval_summary.tsv', sep='\t')
summary_df = summary_df.append(tmp_df, ignore_index=True)
summary_df.to_csv(f'{eval_dir}/eval_summary.tsv', sep='\t', index=False)

# save predictions and results
predictions.to_csv(f'{directory}/evaluation_table_s{split}_e{epoch}.tsv', sep='\t')

# with open("failed_predictions.txt", "w") as output:
#     output.write(str(failed_predictions))