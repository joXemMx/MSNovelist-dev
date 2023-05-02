#!/bin/bash

#SBATCH --partition=gpu_p100,gpu_v100,gpu_a100
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=60000
#SBATCH --nice

source /home/vo87poq/MSNovelist-dev/singularity.env



CMD=${1:-train}
CMD_EXEC=""
OPTS=""
case $CMD in
	"train")
		CMD_EXEC="/msnovelist/train.sh"
		OPTS="--nv"
		;;
	"bash")
		CMD_EXEC="bash"
		OPTS=""
		;;
esac

echo "training_id: '$SLURM_JOB_ID'" > $DATA_LOC/train/$SLURM_JOB_ID.yaml

if [[ "$SLURM_ARRAY_TASK_ID" != "" ]]
then
	echo "training_id: '$SLURM_ARRAY_JOB_ID'" > $DATA_LOC/train/$SLURM_JOB_ID.yaml
	echo "cv_fold: $SLURM_ARRAY_TASK_ID" >> $DATA_LOC/train/$SLURM_JOB_ID.yaml
fi

echo "source _entrypoint.sh" >> $TMPDIR/.bashrc

cp $DB_LOC/*.db $TMPDIR

singularity run \
	$OPTS \
	--bind $TMPDIR:/$HOME \
	--bind $TMPDIR:/sirius6_db \
	--bind $DATA_LOC:/target \
	--bind $CODE_LOC:/msnovelist \
	--bind $DATA_LOC:/data \
	--bind $DATA_LOC:/msnovelist-data \
	$SIF_LOC \
	$CMD_EXEC
