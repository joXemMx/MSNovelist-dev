import pandas as pd
from statistics import median, mean
import os

path = os.path.expanduser('~/MSNovelist-dev')
df = pd.read_csv(f'{path}/independent_set_eval/evaluation_results/eval_summary_adjusted.tsv', sep='\t')

# Recovery
vmean = mean(df['recovery_percentage'])
vmedian = median(df['recovery_percentage'])
vmax = max(df['recovery_percentage'])
vmin = min(df['recovery_percentage'])
print(f'Recovery percentage: mean {float("{:.2f}".format(vmean))}%, median {float("{:.2f}".format(vmedian))}%, max {vmax}%, min {vmin}%')

# Cumulative recovery by position
num_entries = 1601
cumulative_medians = []
cumulative_sum = 0
for col in df[['matches_pos_1', 'matches_pos_2', 'matches_pos_3', 'matches_pos_4', 'matches_pos_5', 'matches_pos_6', 'matches_pos_7', 'matches_pos_8', 'matches_pos_9', 'matches_pos_10']]:
    cumulative_sum += df[col]
    cumulative_median = cumulative_sum.median()
    cumulative_medians.append(cumulative_median)
cumulative_median_df = pd.DataFrame({'cumulative_median': cumulative_medians})
print(f'Cumulative recovery py position (in %): {[round((med/num_entries)*100, 2) for med in cumulative_medians]}')
#print(f'Recovery percentage by position: Pos. 1: {vmedian_pos1}, Pos. 2: {vmedian_pos2}, Pos. 3: {vmedian_pos3}, Pos. 4: {vmedian_pos4}, Pos. 5: {vmedian_pos5}, Pos. 6: {vmedian_pos6}, Pos. 7: {vmedian_pos7}, Pos. 8: {vmedian_pos8}, Pos. 9: {vmedian_pos9}')

# Invalid predictions
vmean = mean(df['invalid_predictions_percentage'])
vmedian = median(df['invalid_predictions_percentage'])
vmax = max(df['invalid_predictions_percentage'])
vmin = min(df['invalid_predictions_percentage'])
print(f'Invalid predictions percentage: mean {float("{:.2f}".format(vmean))}%, median {float("{:.2f}".format(vmedian))}%, max {vmax}%, min {vmin}%')

# Matching formulas
vmean = mean(df['matching_formulas_percentage_full'])
vmedian = median(df['matching_formulas_percentage_full'])
vmax = max(df['matching_formulas_percentage_full'])
vmin = min(df['matching_formulas_percentage_full'])
print(f'Matching formulas percentage: mean {float("{:.2f}".format(vmean))}%, median {float("{:.2f}".format(vmedian))}%, max {vmax}%, min {vmin}%')