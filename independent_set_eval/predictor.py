import minimal_load_model
import utility

class Predictor:
    def predict(mf, fp, filtered=False):
        try: 
            legality, composition_counter = utility.mol_form_processing(mf)
            if legality:
                results_df = utility.predict(composition_counter, mf, fp, filtered, minimal_load_model.k, minimal_load_model.model_encode, minimal_load_model.decoder)
                results_df['smiles'] = results_df['smiles'].str.replace('?', '')
                return results_df
            else: 
                print(f"The molecular formula {mf} does not fit into the list of allowed elements {utility.ELEMENTS_RDKIT}.")
                return None
        except Exception as e:
            print(e)
            return None