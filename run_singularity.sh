#!/bin/bash

#SBATCH --partition=s_standard
#SBATCH --nodes=1
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

#cp $DB_LOC/*.db $TMPDIR

module load tools/singularity/3.7.0

singularity run \
	$OPTS \
	--bind $HOME_LOC:/$HOME \
	--bind $TEMP_LOC:/tmp \
	--bind $DB_LOC:/sirius6_db \
	--bind $DATA_LOC:/target \
	--bind $CODE_LOC:/msnovelist \
	--bind $DATA_LOC:/data \
	--bind $DATA_LOC:/msnovelist-data \
	$SIF_LOC \
	$CMD_EXEC
