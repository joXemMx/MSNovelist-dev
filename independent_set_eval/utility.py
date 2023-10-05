from collections import Counter
import molmass
import infrastructure.generator as gen
import tensorflow as tf
from rdkit import Chem
from rdkit.Chem import rdMolDescriptors
import matplotlib.pyplot as plt


ELEMENTS_RDKIT = ['C','F','I','Cl','N','O','P','Br','S','H']

# Check if unique elements of molecular formula are withing the 10 allowed
def mol_form_processing(formula):
    composition_counter = Counter({e[0]: e[1] for e in molmass.Formula(formula).composition()})
    elements = list(composition_counter.keys())
    legality = set(elements).issubset(ELEMENTS_RDKIT)
    del elements
    return legality, composition_counter


def predict(composition_counter, fp, k, model_encode, decoder):
    fo = [composition_counter]
    fo_ = gen.mf_pipeline(fo).astype('float32')
    nh = fo_[:,-1]
    
    data = {'fingerprint_selected': [fp], 
            'mol_form': fo_,
            'n_hydrogen': nh}
        
    data_k = {key: tf.repeat(x, k, axis=0) for key, x in data.items()}
    states_init = model_encode.predict(data_k)
    # predict k sequences for each query.
    sequences, y, scores = decoder.decode_beam(states_init)
    seq, score, _ = decoder.beam_traceback(sequences, y, scores)
    smiles = decoder.sequence_ytoc(seq)
    
    results_df = decoder.format_results(smiles, score)
    return results_df


def normalize_smiles(smiles):
    smiles = smiles.replace('?', '')
    mol = Chem.MolFromSmiles(smiles)
    if mol is not None:
        return Chem.MolToSmiles(mol)
    return 'invalid'


def matching_atom_count(smiles, formula):
    # Get molecular formula, including implicit hydrogens
    mol = Chem.MolFromSmiles(smiles)
    mf = rdMolDescriptors.CalcMolFormula(mol)
    # Compare to input molecular formula, add as valid if equal
    if mf == formula:
        return True
    return False


def match_smiles(true_smiles, predictions):
    matches = []
    for pred in predictions:
        if true_smiles == pred:
            matches.append(1)
            # if hit is found, set rest to 0
            matches += [0] * (128 - len(matches))
            return matches, True
        matches.append(0)
    return matches, False


def plot_recovery_curve(hit_positions, total_size, split, epoch, directory):
    recovery_percentages = []
    current_recovery = 0

    for i in range(1, 12):  # Calculate up to position 11
        hits_at_position = hit_positions.count(i)
        current_recovery += (hits_at_position / total_size) * 100
        recovery_percentages.append(current_recovery)

    # Plot the recovery curve
    positions = list(range(1, 12))
    plt.step(positions, recovery_percentages, where='post', color='b')
    plt.xlabel('Rank of predicted structure by RNN score')
    plt.ylabel('Percentage of correctly recovered structures')
    plt.title(f'Rank of correct structure in results (weights of split {split}, epoch {epoch})')
    plt.xlim(1,10.95)
    plt.xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    plt.ylim(0, max(recovery_percentages) + 5)
    overall_recovery = (len(hit_positions) / total_size) * 100
    plt.text(1.5, max(recovery_percentages) + 2.5, f'Total recovery: {overall_recovery:.2f}%', bbox=dict(facecolor='white', alpha=1))

    plt.savefig(f'{directory}/recovery_plot_s{split}_e{epoch}.png', dpi=300)


def get_formulas_from_smiles(smiles):
    formulas = []
    for smiles_real in smiles:
        try:
            mol = Chem.MolFromSmiles(smiles_real)
            mf = rdMolDescriptors.CalcMolFormula(mol)
            mf = mf.replace('+', '').replace('-', '')
            formulas.append(mf)
        except:
            formulas.append('invalid')
    return formulas