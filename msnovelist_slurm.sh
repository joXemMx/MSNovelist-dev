#!/bin/bash
#SBATCH --partition=gpu_a100,gpu_v100,gpu_p100
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32000
#SBATCH --nice
#SBATCH --output="/home/vo87poq/MSNovelist-dev/13_training_subclass.out"

source ~/miniconda3/etc/profile.d/conda.sh
conda activate msnovelist-env
cd /home/vo87poq/MSNovelist-dev
export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev
#python preprocessing_sirius6/06_remove_duplicates.py
python /home/vo87poq/MSNovelist-dev/training_subclass.py