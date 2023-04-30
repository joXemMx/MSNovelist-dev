#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate msnovelist-env

cd ~/MSNovelist-dev/preprocessing_sirius6
export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev

python 01_import_training.py
echo "FINISHED 01_import_training"
python 02_import_validation.py
echo "FINISHED 02_import_validation"
python 03_check_training.py
echo "FINISHED 03_check_training"
python 04_check_validation.py
echo "FINISHED 04_check_validation"
python 05_write_invalid.py
echo "FINISHED 05_write_invalid"
python 06_remove_duplicates.py
echo "FINISHED 06_remove_duplicates"
./backup.sh
echo "FINISHED backup after python scripts"

./07_set_folds.sh
echo "FINISHED 07_set_folds"
./08_fold_index.sh
echo "FINISHED 08_fold_index"
./09_randomize.sh
echo "FINISHED 09_randomize"
./backup.sh
echo "FINISHED backup after 09_randomize"

./10_subset_training.sh
echo "FINISHED 10_subset_training"
./11_inchifolds_crossval.sh
echo "FINISHED 11_inchifolds_crossval"
./12_subset_crossval.sh
echo "FINISHED 12_subset_crossval"
./backup.sh
echo "FINISHED backup after shell scripts"