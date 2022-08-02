#!/bin/bash
#SBATCH --job-name=maskrcnn
#SBATCH --gres gpu:8
#SBATCH --nodes 1
#SBATCH --cpus-per-task 48
#SBATCH --ntasks-per-node 1
#SBATCH --signal=USR1@1000
#SBATCH --partition=long,user-overcap
#SBATCH --qos=ram-special
#SBATCH --constraint=a40
#SBATCH --output=slurm_logs/maskrcnn-%j.out
#SBATCH --error=slurm_logs/maskrcnn-%j.err
#SBATCH --requeue

source /srv/flash1/rramrakhya6/miniconda3/etc/profile.d/conda.sh
conda deactivate
conda activate ml_hw4

export GLOG_minloglevel=2
export MAGNUM_LOG=quiet

MASTER_ADDR=$(srun --ntasks=1 hostname 2>&1 | tail -n1)
export MASTER_ADDR

./tools/dist_train.sh configs/balloon/mask_rcnn_r50_150k.py 8 --no-validate
