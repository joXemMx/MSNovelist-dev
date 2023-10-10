from rdkit import Chem
from rdkit.Chem import rdMolDescriptors


# These methods need data from the 'InChI' column, not 'InChIKey14' !!!

def inchi_to_smiles(inchi):
    mol = Chem.inchi.MolFromInchi(inchi)
    if mol is not None:
        return Chem.MolToSmiles(mol)
    return 'invalid'


def inchi_to_formula(inchi):
    try:
        mol = Chem.inchi.MolFromInchi(inchi)
        mf = rdMolDescriptors.CalcMolFormula(mol)
        mf = mf.replace('+', '').replace('-', '')
        return mf
    except:
        return 'invalid'