import pandas as pd
from rdkit import Chem


def normalize_smiles(smiles):
    smiles = smiles.replace('?', '')
    mol = Chem.MolFromSmiles(smiles)
    if mol is not None:
        return Chem.MolToSmiles(mol), mol
    return None, None


def check_atom_count(smiles, mol, rnn_score, allowed_element_count, elements, valid_unique_smiles):
    # Add implicit hydrogens
    mol = Chem.AddHs(mol)
    element_count = mol.GetNumAtoms()
    element_counter = allowed_element_count.copy()

    # Check for correct sum of atoms
    if element_count == sum(element_counter):
        # Count single atoms
        for atom in mol.GetAtoms():
            symbol = atom.GetSymbol()
            if symbol not in elements:
                return
            index = elements.index(symbol)
            if element_counter[index] == 0:
                return 
            element_counter[index] -= 1

    if all(count == 0 for count in element_counter):
        print(element_counter)
        valid_unique_smiles[smiles] = rnn_score
    

def filter_and_unique_smiles(df, allowed_element_count, elements):
    unique_entries = {}
    valid_unique_smiles = {}

    for smiles, rnn_score in zip(df['smiles'], df['rnn_score']):
        normalized_smiles, mol = normalize_smiles(smiles)
        # mol is not hashable and can not be used in set(), do dictionary using smiles instead
        if normalized_smiles is not None and normalized_smiles not in unique_entries:
            unique_entries[normalized_smiles] = [mol, rnn_score]
        # keep highest rnn_score of same (normalized!) SMILES
        elif rnn_score > unique_entries[normalized_smiles][1]:
            unique_entries[normalized_smiles][1] = rnn_score

    for smiles, info in unique_entries.items():
        mol = info[0]
        rnn_score = info[1]
        check_atom_count(smiles, mol, rnn_score, allowed_element_count, elements, valid_unique_smiles)
            
    return pd.DataFrame(list(valid_unique_smiles.items()), columns=['smiles', 'rnn_score'])




# Sample DataFrame with 'smiles' and 'rnn_score' columns
import pandas as pd
data = {
    'smiles': ['CCO', 'CCO', 'C=O', 'C=O', 'CC', 'CCO', 'CCO', 'CCC', 'CCCN'],
    'rnn_score': [0.5, 0.6, 0.7, 0.8, 0.9, 0.4, 0.8, 0.2, 0.1]
}
df = pd.DataFrame(data)

# Allowed element count represented by an array
elements = ['C', 'O', 'H']
allowed_element_count = [2,1,6]

# Filter out invalid and duplicate smiles that match the element count constraint
result_df = filter_and_unique_smiles(df, allowed_element_count, elements)
print(result_df)
