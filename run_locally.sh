#!/bin/bash

export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev
source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env
cd /home/vo87poq/MSNovelist-dev
now=$(date +%s)
mkdir $now

for i in {0..9}
do
    echo "training_id: '$i'" > $now/job_$i.yaml
	echo "cv_fold: $i" >> $now/job_$i.yaml
    python training_subclass.py -c config.yaml $now/job_$i.yaml
done
