#!/bin/bash

source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env

cd ~/MSNovelist-dev/preprocessing_sirius6
export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev

python 01_import_training.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 01_import_training"
python 02_import_validation.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 02_import_validation"
python 03_check_training.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 03_check_training"
python 04_check_validation.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 04_check_validation"
python 05_write_invalid.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 05_write_invalid"
python 06_remove_duplicates.py |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 06_remove_duplicates"
bash backup.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED backup after python scripts"

bash 07_set_folds.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 07_set_folds"
bash 08_fold_index.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 08_fold_index"
bash 09_randomize.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 09_randomize"
bash backup.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED backup after 09_randomize"

bash 10_subset_training.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 10_subset_training"
bash 11_inchifolds_crossval.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 11_inchifolds_crossval"
bash 12_subset_crossval.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED 12_subset_crossval"
bash backup.sh |& tee -a ~/MSNovelist-dev/preprocessing_sirius6/wallace_output.txt
echo "FINISHED backup after shell scripts"