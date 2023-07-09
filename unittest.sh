#!/bin/bash

export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev

source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env

python /home/vo87poq/MSNovelist-dev/unittests/test_fingerprinter.py