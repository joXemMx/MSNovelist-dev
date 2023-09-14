#!/bin/bash

export COMPUTERNAME=DOCKER-LIGHT
export MSNOVELIST_BASE=/home/vo87poq/MSNovelist-dev
#export TF_XLA_FLAGS=--tf_xla_cpu_global_jit
source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env
cd /home/vo87poq/MSNovelist-dev
mkdir -p trainings
now=$(date +%s)
mkdir trainings/$now

# python -c "import tensorflow as tf;\
#     config = tf.compat.v1.ConfigProto(\
#     inter_op_parallelism_threads=600,\
#     intra_op_parallelism_threads=600);\
#     session = tf.compat.v1.Session(config=config);\
#     tf.config.run_functions_eagerly(True);\
#     tf.config.threading.set_inter_op_parallelism_threads(600); tf.config.threading.set_intra_op_parallelism_threads(600)"

folds=(7 8 9)

for i in "${folds[@]}"
do
    echo "training_id: '${now}_${i}'" > trainings/${now}/job_${i}.yaml
	echo "cv_fold: $i" >> trainings/${now}/job_${i}.yaml
    python train.py -c config.yaml trainings/${now}/job_${i}.yaml |& tee trainings/${now}/job_${i}_output.txt &
done
