#!/bin/bash

export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev
source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env
cd /home/vo87poq/MSNovelist-dev
mkdir -p trainings
now=$(date +%s)
mkdir trainings/$now

for i in 1
do
    echo "training_id: '$i'" > trainings/${now}/job_${i}.yaml
	echo "cv_fold: $i" >> trainings/${now}/job_${i}.yaml
    python training_subclass.py -c config.yaml trainings/${now}/job_${i}.yaml |& tee trainings/${now}/job_${i}_output.txt
done
